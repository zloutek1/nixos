{ ... }: {

  networking.firewall = {
    allowedTCPPorts = [ 22000 ];   # Syncthing sync port (TCP)
    allowedUDPPorts = [ 22000 21027 ];  # Sync + discovery ports (UDP)
  };

}