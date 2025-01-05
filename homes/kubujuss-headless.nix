{
  imports = [
    ./modules/fastfetch.nix
    ./modules/git.nix

    ./modules/nvim
    ./modules/bash
    ./modules/tmux
  ];

  programs.home-manager.enable = true;

  home = {
    username = "kubujuss";
    homeDirectory = "/home/kubujuss";
    stateVersion = "24.05";
  };
}
