{
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.cache/wal/colors-alacritty.toml"
      ];

      window = {
        opacity = 0.75;
        dynamic_padding = true;
      };

      font = {
        size = 10;
        normal = {
          family = "JetbrainsMono Nerd Font";
          style = "Regular";
        };
      };
    };
  };
}
