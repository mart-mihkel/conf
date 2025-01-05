{ pkgs, ... }:

{
  home = {
    file.".config/hypr".source = ./.;
    packages = with pkgs; [ 
      hyprland
      hyprpaper
      hypridle
      hyprlock

      brightnessctl
      noto-fonts
      nerdfonts
      gammastep
      slurp
      grim
    ];
  };
}
