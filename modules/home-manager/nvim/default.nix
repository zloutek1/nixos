{ ... }: {

  home.file.".config/nvim/lua/custom/kitty_padding.lua" = {
    source =./kitty_padding.lua;
  };

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;

    extraConfig = ''
      require('custom.kitty_padding')
    '';
  };

  # IMPORTANT: Ensure standard neovim module is disabled
  programs.neovim.enable = false;

  environment.systemPackages = with pkgs; [
    # clangd (c, c++, etc lang server)
    # and other cli tools
    clang-tools clang-manpages
    cmake-language-server
  ];


}