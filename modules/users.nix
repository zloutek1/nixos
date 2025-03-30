{ pkgs, ... }: {

    users.users = {
      
        tomas = {
            isNormalUser = true;
            description = "tomas";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [];
        };

    };

}