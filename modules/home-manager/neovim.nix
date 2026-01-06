{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    neovim = {
      enable = lib.mkEnableOption "enables custom neovim package";

      profile = lib.mkOption {
        type = lib.types.enum ["base" "full"];
        default = "base";
        description = ''
          Which nvf profile to use:
          - base: Basic editing without LSP
          - full: Complete setup with LSP and completion
        '';
      };
    };
  };

  config = lib.mkIf config.neovim.enable {
    home.packages = [
      inputs.nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.${config.neovim.profile}
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
