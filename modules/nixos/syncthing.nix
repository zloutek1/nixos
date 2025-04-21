{ host, ... }: {

  # TODO: move to a home manager module
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    settings = {
      gui = {
        user = "tomas";
        password = "pass123";
      };
    };
  };

}