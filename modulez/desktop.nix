{ config, pkgs, lib, ... }:
{
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    terminus_font
    jetbrains-mono
    powerline-fonts
    gelasio
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    ttf_bitstream_vera
    terminus_font_ttf
  ];


  environment.systemPackages = with pkgs; [
    librewolf
    xscreensaver
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # services.xserver.desktopManager.xfce.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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


}
