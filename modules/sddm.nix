{ pkgs, ... }: {
  
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
    wayland.enable = true;
    autoNumlock = true;
  };
  
  environment.systemPackages = [ pkgs.sddm-astronaut ];

}
