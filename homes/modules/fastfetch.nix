{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
      };
      display = {
        size = {
          ndigits = 0;
          maxPrefix = "MB";
        };
      };
      modules = [
        "title"
        "os"
        "packages"
        "wm"
        "cpu"
        "gpu"
        {
          type = "memory";
          format = "{} / {}";
        }
      ];
    };
  };
}
