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
    services.pulseaudio.enable = false;
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

    programs.firefox = {
      enable = true;
      policies.Homepage.StartPage = "about:blank";
      policies.DisableTelemetry = true;
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        # Microsoft-compatible fonts
        corefonts
        liberation_ttf

        # Programming fonts
        fira-code
        fira-code-symbols
        jetbrains-mono
        cascadia-code
        hack-font
        source-code-pro
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono

        # Sans-serif fonts
        dejavu_fonts
        inter
        roboto
        cantarell-fonts
        ubuntu-classic

        # Serif fonts
        gelasio
        roboto-slab

        # CJK and emoji
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji

        # Icon fonts
        font-awesome

        # Other
        powerline-fonts
        ttf_bitstream_vera
      ];
    };

    environment.systemPackages = with pkgs; [
      librewolf
      nordic
      vlc
      vscode
      pciutils
      clinfo
      mesa-demos
      vulkan-tools
      ghostty
      kdePackages.kate
    ];
  };
}
