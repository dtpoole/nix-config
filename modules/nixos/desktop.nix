{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktop.enable = lib.mkEnableOption "enables desktop module";
  };

  config = lib.mkIf config.desktop.enable {
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
      thunderbird
      vlc
      vscode
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # services.xserver.desktopManager.xfce.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    sound.enable = true;
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
  };
}
