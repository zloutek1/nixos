{ pkgs, ... }: {

  services.wlsunset = {
    enable = true;
    latitude = 49.1951;
    longitude = 16.6068;
  };

  home.packages = with pkgs; [
    wlsunset
  ];

}