# An ancient Dell Optiplex 360 I got off of eBay a few years ago for $40.
# It's called Donkey because it's slow, but I'll use it to hold data
# for me as a NAS.
{ self, ... }: {
  imports = with self.nixosModules; [
    ./hardware-configuration.nix

    bm-server
    sshd
    wireguard-client
    zerotier
    zfs-boot
  ];

  astral.infra-update.enable = true;

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "donkey";
    domain = "id.astrid.tech";

    hostId = "49e32584";
    networkmanager.enable = true;
    useDHCP = false;

    interfaces.enp2s0.useDHCP = true;
  };

  boot.loader.grub = {
    # The big disk that has root
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WMC6Y0K8MU3V";
    efiSupport = false;
    enable = true;
    version = 2;
  };
}

