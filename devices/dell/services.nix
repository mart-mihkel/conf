{
  services = {
    tlp.enable = true;

    pcscd.enable = true;

    undervolt = {
      enable = true;
      coreOffset = -100;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        terminal = { vt = 1; };
        default_session = {
          command = "hyprland";
          user = "kubujuss";
        };
      };
    };
  };
}
