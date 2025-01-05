{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ 
    gnumake
    nodejs
    cargo
    tmux
    curl
    wget
    tree
    wol
    git
    gcc
    vim
    uv
    jq
  ];
}
