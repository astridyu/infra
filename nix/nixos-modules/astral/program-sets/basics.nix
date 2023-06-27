{
  name = "basics";
  description = "Useful utilities for terminal environments";
  enableByDefault = true;
  progFn = { pkgs }: {
    programs = {
      # Neovim is cool and good
      neovim = {
        enable = true;
        viAlias = true;
      };

      # Just in case the SSH connection is lost and I'm running something long
      tmux = { enable = true; };
    };

    environment.systemPackages = with pkgs; [
      # Download stuff from the internet
      git
      git-lfs
      curl
      wget

      # Useful scripting utilities
      envsubst
      jq
      mktemp
      python3
      tree
      unixtools.xxd
      yq

      # Other utilities
      bind
      ed
      elinks
      ethtool
      file
      iftop
      iotop
      iperf
      neofetch
      nmap
      p7zip
      pciutils
      psmisc
      speedtest-rs
      tcpdump
      unzip
      usbutils
      uwufetch
      zip
    ];
  };
}
