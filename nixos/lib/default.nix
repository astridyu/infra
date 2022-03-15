{ nixpkgs, baseModules, home-manager }: rec {
  # Make a system customized with my stuff.
  mkSystem = { hostName, module ? { }, modules ? [ ], system ? "x86_64-linux"
    , domain ? "id.astrid.tech" }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = baseModules ++ [
        {
          networking = {
            inherit hostName;
            inherit domain;
          };
        }
        module
      ] ++ modules;
    };

  # Make multiple system entries in a nice way.
  mkSystemEntries =
    builtins.mapAttrs (hostName: module: mkSystem { inherit hostName module; });

  # Make a Pi jumpserver system in a nice way.
  mkPiJumpserver = { hostName, module ? { } }:
    (mkSystem {
      inherit hostName;
      system = "aarch64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];

          time.timeZone = "US/Pacific";

          astral = {
            roles.server.enable = true;
            zfs-utils.enable = false;
          };

          # Don't compress the image.
          sdImage.compressImage = false;
        })
        module
      ];
    });

  # Make multiple pi jumpserver systems in a nice way.
  mkPiJumpserverEntries = builtins.mapAttrs
    (hostName: module: mkPiJumpserver ({ inherit hostName module; }));

  mkHomeConfig = { module ? [], system ? "x86_64-linux" }:
    home-manager.lib.homeManagerConfiguration {
      inherit system;
      homeDirectory = "/home/astrid";
      username = "astrid";
      configuration = module;
    };
}