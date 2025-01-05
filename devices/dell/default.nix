{ lib, config, ... }:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./services.nix
    ./boot.nix

    ../modules/common
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
  };

  programs.hyprland.enable = true;
  security.pam.services.hyprlock = {};

  system.stateVersion = "24.05";
}
