{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
    ];
  };

  home.file.".config/nvim".source = ./.;
}
