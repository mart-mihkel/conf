{ pkgs, ... }:

{
  programs.rofi.enable = true;

  home = {
    file.".config/rofi".source = ./.;
    packages = with pkgs; [
      rofi-emoji
    ];
  };
}
