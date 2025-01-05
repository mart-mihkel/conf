{ pkgs, ... }:

{
  programs.eww = {
    enable = true;
    configDir = ./.;
  };

  home.packages = with pkgs; [ 
    socat
  ];
}
