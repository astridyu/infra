# A NUC that's my media server, hooked up to the telly
{ pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.self.nixosModules.server

    inputs.self.nixosModules.media-server
  ];

  networking = {
    hostName = "bonney";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";

  virtualisation.podman.enable = true;
  virtualisation.vmVariant = {
    # Autologin as root because we testin here
    services.getty.autologinUser = "root";

    services.nginx.virtualHosts."localhost".locations."/" = {
      proxyPass = "http://localhost:80";
      # Route request to deluge web
      extraConfig = ''
        proxy_set_header Host "deluge.s02.astrid.tech";
      '';
    };

    virtualisation = {
      graphics = false;
      diskSize = 8192;

      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
        {
          from = "host";
          guest.port = 80;
          host.port = 8080;
        }
      ];
    };
  };
}
