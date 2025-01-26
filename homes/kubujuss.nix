{ pkgs, ... }:

{
  imports = [
    ./modules/fastfetch.nix
    ./modules/git.nix

    ./modules/alacritty
    ./modules/nvim
    ./modules/hypr
    ./modules/rofi
    ./modules/bash
    ./modules/tmux
    ./modules/eww
    ./modules/wal
  ];

  programs.home-manager.enable = true;

  home = {
    username = "kubujuss";
    homeDirectory = "/home/kubujuss";

    packages = with pkgs; [
      cloudflared
      web-eid-app
      qdigidoc
      firefox
      dunst
      slack
      zoom
      ccid
    ];

    stateVersion = "24.05";
  };
}
