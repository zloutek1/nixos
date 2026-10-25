{ ... }: {

  programs.git = {
    # enable = true;
    settings = {
      user.name = "Tomáš Ljutenko";
      user.email = "tomas.ljutenko@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

}
