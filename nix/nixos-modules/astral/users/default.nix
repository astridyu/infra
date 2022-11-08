# Normal user declarations.
{ self }:
let inherit (self.lib) sshKeyDatabase;
in {
  imports = let
    # Helper to create a user with the given name.
    mkUserModule = name:
      { description, isAutomationUser ? false, sshKeys ? [ ]
      , enableByDefault ? false, defaultGroups ? [ ] }:
      { pkgs, lib, config, ... }:
      with lib; {
        options.astral.users."${name}" = {
          enable = mkOption {
            description = "Enable ${
                if isAutomationUser then "system" else "normal"
              } user ${user}";
            default = enableByDefault;
            type = types.bool;
          };

          extraGroups = mkOption {
            description = "Extra groups for ${user}";
            default = [ ];
            type = types.listOf types.string;
          };
        };

        config.users.users."${name}" = let cfg = config.astral.users."${name}";
        in mkIf cfg.enable {
          inherit description;

          openssh.authorizedKeys.keys = sshKeys;
          extraGroups = defaultGroups ++ cfg.extraGroups;

          createHome = !isAutomationUser;
          isNormalUser = !isAutomationUser;
          isSystemUser = isAutomationUser;

          shell = mkIf isAutomationUser pkgs.bashInteractive;

          group = "automaton";
        };
      };

  in [
    { users.groups.automaton = { }; }
    (mkUserModule "astrid" {
      description = "Astrid Yu";
      enableByDefault = true;
      sshKeys = sshKeyDatabase.users.astrid;
      defaultGroups = [
        "dialout"
        "docker"
        "i2c"
        "libvirtd"
        "lxd"
        "netdev"
        "networkmanager"
        "plugdev"
        "vboxsf"
        "vboxusers"
        "wheel"
      ];
    })
    (mkUserModule "alia" {
      description = "Alia Lescoulie";
      sshKeys = sshKeyDatabase.users.alia;
    })

    (mkUserModule "terraform" {
      description = "Terraform Cloud actor";
      sshKeys = sshKeyDatabase.users.terraform;
      isAutomationUser = true;
      defaultGroups = [ "wheel" ];
    })
    (mkUserModule "github" {
      description = "Github Actions actor";
      sshKeys = sshKeyDatabase.users.github;
      isAutomationUser = true;
      defaultGroups = [ "wheel" ];
    })
  ];
}