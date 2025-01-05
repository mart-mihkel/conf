{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;

    nvidia-container-toolkit.enable = true;

    nvidia = {
      open = true;

      nvidiaSettings = true;
      nvidiaPersistenced = true;

      powerManagement.enable = true;

      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
