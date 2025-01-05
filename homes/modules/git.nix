{
  programs.git = {
    enable = true;
    userName = "mart-mihkel";
    userEmail = "mart.mihkel.aun@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = true;
    };
  };
}
