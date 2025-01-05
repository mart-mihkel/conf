{
  boot = {
    loader.systemd-boot.enable = true;

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
}
