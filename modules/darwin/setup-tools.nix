{ lib, config, ... }: {

  # accept the licenses needed to install some apps
  system.activationScripts.postActivation = {
    text = ''
      # Install Rosetta 2 if not present (needed on Apple Silicon for x86_64 apps)
      if [[ "$(uname -m)" == "arm64" ]]; then
        if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
          echo "Installing Rosetta 2..."
          /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        fi
      fi

      # Install Xcode Command Line Tools if not present
      if ! /usr/bin/xcrun -f clang >/dev/null 2>&1; then
        echo "Installing Command Line Tools..."
        /usr/bin/xcode-select --install & # Run in background
      fi
    '';
  };

}