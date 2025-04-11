{ ... }: {

  programs.git = {
    enable = true;
    userName = "Tomáš Ljutenko";
    userEmail = "tomas.ljutenko@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

}