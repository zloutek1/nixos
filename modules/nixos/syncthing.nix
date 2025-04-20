{ username, host, ... }: {

  # TODO: move to a home manager module
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    settings = {
      gui = {
        user = username;
        password = "pass123";
      };
    };
  };

}