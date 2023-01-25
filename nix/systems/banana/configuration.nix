# My gaming laptop.
{ pkgs, lib, inputs, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.pc
    inputs.self.nixosModules.laptop
  ];

  time.timeZone = "US/Pacific";

  astral.vfio = {
    enable = true;
    iommu-mode = "intel_iommu";
    pci-devs = [ ];
  };

  # so i can be a *gamer*
  programs.steam.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services = {
    xserver.videoDrivers = [ "nvidia" ];
    blueman.enable = true;
  };

  virtualisation.lxd.enable = true;

  hardware = {
    opengl.enable = true;

    nvidia.prime = {
      # Sync mode for multi-monitor support https://nixos.wiki/wiki/Nvidia#sync_mode
      sync.enable = true;
      offload.enable = false;

      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    bluetooth.enable = true;
  };

  networking = {
    hostName = "banana";

    hostId = "76d4a2bc";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    # rtw_8822be issue? https://bbs.archlinux.org/viewtopic.php?id=260589
    kernelParams = [ "pcie_aspm.policy=powersave" ];
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        version = 2;
        useOSProber = true;
        splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };

  specialisation."offload".configuration = {
    hardware.nvidia.prime = {
      sync.enable = mkForce false;
      offload.enable = mkForce true;
    };
  };

  # Windows drive
  fileSystems."/dos/c" = {
    device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
    fsType = "ntfs";
    options = [ "rw" ];
  };
}

