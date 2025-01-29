{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      ripgrep
    ];
  };

  home.file.".config/nvim".source = ./.;
}
