{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true; # Required for Nvidia proprietary drivers

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.kernelModules = [ "kvm-intel" ]; # For virtualization

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Needed for 32-bit apps like Steam

    extraPackages = with pkgs; [
      intel-media-driver # Modern Intel VAAPI driver (iHD)
      libvdpau-va-gl # VDPAU frontend for VAAPI
      nvidia-vaapi-driver # VAAPI backend for Nvidia
      intel-gpu-tools # Useful Intel GPU utilities
      # vulkan-tools          # Optional: for Vulkan diagnostics
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver # 32-bit Intel VAAPI
    ];
  };

  # Load Nvidia driver necessary for Wayland/XWayland/PRIME
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Essential for Wayland compositors
    modesetting.enable = true;

    # Recommended for Turing (RTX 20) / Ada (RTX 40) GPUs
    open = true;

    # Use stable driver initially for reliability
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Disable experimental power management initially for stability
    # Can cause suspend/resume issues
    powerManagement.enable = false;

    # Enable nvidia-settings utility for diagnostics
    nvidiaSettings = true;

    # Configure PRIME Render Offload
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload command
      };
      #!! VERIFY these IDs using `lspci | grep -E 'VGA|3D'`!!
      # Convert hex (e.g., 00:02.0) to decimal PCI:Bus:Device:Function
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Kernel parameters specific to Nvidia/Wayland
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Essential for Nvidia + Wayland
    # "nvidia-drm.fbdev=1" # Omit initially. Can cause TTY/boot issues. Add ONLY if Wayland shows black screen after verifying other settings.
  ];

  environment.sessionVariables = {
    # Fix Nvidia cursor rendering issues in wlroots compositors (like Hyprland)
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
