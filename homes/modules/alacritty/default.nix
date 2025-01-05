{
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = true;

      font = {
        size = 11;
        normal = {
          family = "JetbrainsMono Nerd Font";
          style = "Regular";
        };
      };

      colors = {
        cursor = { 
          text = "#0d0e0c";
          cursor = "#c8b6b8";
        };

        primary = {
          background = "#ffffff";
          foreground = "#6b6b6b";
        };
      };
    };
  };
}
