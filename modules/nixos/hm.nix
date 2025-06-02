{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    hm = {
      enable = lib.mkEnableOption "enables home-manager integration";

      username = lib.mkOption {
        type = lib.types.str;
        default = "dave";
        description = "Username for home-manager configuration";
      };

      configPath = lib.mkOption {
        type = lib.types.path;
        default = ../../modules/home-manager;
        description = "Path to home-manager configuration";
      };
    };
  };

  config = lib.mkIf config.hm.enable {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.hm.username} = import config.hm.configPath;
      extraSpecialArgs = {
        inherit inputs;
        username = config.hm.username;
      };
    };
  };
}
