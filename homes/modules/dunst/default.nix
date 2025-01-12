{ pkgs, ... }:

{
  home = {
    file.".config/dunst".source = ./.;
    packages = with pkgs; [ dunst ];
  };
}
