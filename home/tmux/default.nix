{ config, lib, pkgs, ... }: {
  xdg.configFile."tmux/tmux.conf".text = builtins.readFile ./tmux.conf;
}
