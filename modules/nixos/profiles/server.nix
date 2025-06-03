{
  imports = [
    ./base.nix
    ../tailscale.nix
    ../zram.nix
    ../beszel.nix
  ];

  tailscale.enable = true;
  zram.enable = true;

  services.beszel-agent.enable = true;

}
