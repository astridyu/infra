{ pkgs }:
let
  packages = with pkgs;
    [
      ansible
      backblaze-b2
      bitwarden-cli
      curl
      dnsutils
      docker
      docker-compose
      gh
      git
      helmfile
      jq
      kubectl
      kubernetes-helm
      netcat
      nixfmt
      nodePackages.prettier
      packer
      python3
      tcpdump
      terraform
      terraform-ls
      wget
      whois
      yq
    ] ++ (if pkgs.system != "x86_64-darwin" then [
      cdrkit
      iputils
      qemu
    ] else
      [ ]);
in {
  default = pkgs.mkShell { nativeBuildInputs = packages; };

  xmonad-dev = pkgs.haskellPackages.shellFor {
    withHoogle = true;
    packages = self: [ ];
    buildInputs = with pkgs.haskellPackages; [
      haskell-language-server
      ghcid
      cabal-install
    ];
  };
}
