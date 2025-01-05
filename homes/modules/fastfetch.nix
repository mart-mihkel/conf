{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
      };
      display = {
        separator = "  ";
        size = {
          ndigits = 0;
          maxPrefix = "MB";
        };
        key = {
          type = "icon";
        };
      };
      modules = [
        "title"
        "os"
        "kernel"
        "packages"
        "wm"
        "cpu"
        "gpu"
        "memory"
      ];
    };
  };
}
