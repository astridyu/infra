{ self, nixos-generators, nixpkgs, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  vendored-images = import ./images/vendored { inherit pkgs; };
  build-support = import ./build-support { inherit nixos-generators pkgs; };
in vendored-images // {

  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker { };
  installer-iso = pkgs.callPackage ./images/installer-iso { inherit self; };

  ifd3f-infra-scripts = pkgs.callPackage ./../../scripts { };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [{
    name = "centos-8.qcow2";
    path = vendored-images.vendored-centos-8-cloud;
  }];

  win10hotplug = pkgs.callPackage ./win10hotplug { };
}

