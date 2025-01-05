{ lib, config, ... }:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./services.nix
    ./boot.nix

    ../modules/ssh.nix

    ../modules/common
    ../modules/cuda
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "24.05";
}
