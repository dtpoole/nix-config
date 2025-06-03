{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    profiles.desktop.enable = lib.mkEnableOption "Desktop profile";
  };

  config = lib.mkIf config.profiles.desktop.enable {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    programs.firefox.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        corefonts
        fira-code
        fira-code-symbols
        gelasio
        jetbrains-mono
        nerdfonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        powerline-fonts
        source-code-pro
        ttf_bitstream_vera
        ubuntu_font_family
      ];
    };

    environment.systemPackages = with pkgs; [
      librewolf
      nordic
      vlc
      vscode
      pciutils
      clinfo
      glxinfo
      vulkan-tools
      ghostty
      kdePackages.kate
    ];

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
  };
}
