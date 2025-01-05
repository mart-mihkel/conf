{
  networking = {
    hostName = "jaam";
    networkmanager.enable = false;

    interfaces.enp9s0.wakeOnLan.enable = true;
    firewall.allowedUDPPorts = [ 9 ];
  };
}
