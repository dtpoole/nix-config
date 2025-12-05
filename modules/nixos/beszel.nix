{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.beszel-agent;
in {
  options.services.beszel-agent = {
    enable = mkEnableOption "Beszel agent service";
  };

  config = mkIf cfg.enable {
    age.secrets.beszel_agent.file = ../../secrets/beszel_agent_env.age;

    services.beszel.agent = {
      enable = true;
      package = pkgs.unstable.beszel;
      environmentFile = config.age.secrets.beszel_agent.path;
    };
  };
}
