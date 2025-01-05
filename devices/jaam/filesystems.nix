{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/media/ssd-256gb-sata" = {
      device = "/dev/disk/by-label/ssd-256gb-sata";
      fsType = "ext4";
    };

    "/media/hdd-1tb-sata" = {
      device = "/dev/disk/by-label/hdd-1tb-sata";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];
}
