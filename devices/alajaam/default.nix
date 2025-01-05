{ lib, ... }:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./boot.nix

    ../modules/ssh.nix

    ../modules/common
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  system.stateVersion = "24.05";
}
