{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "nixpkgs-darwin";
        home-manager.follows = "home-manager";
      };
    };

    nvf-config = {
      url = "github:dtpoole/nvf-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    systems = ["x86_64-linux" "aarch64-darwin"];
    forEachSystem = lib.genAttrs systems;

    overlays = [(import ./overlays {inherit inputs;})];

    overlayModule = {nixpkgs.overlays = overlays;};

    commonModules = [overlayModule inputs.agenix.nixosModules.default];

    commonDarwinModules = [overlayModule inputs.agenix.darwinModules.default];

    # for standalone home manager
    pkgsFor = forEachSystem (
      system:
        import (
          if lib.hasSuffix "-darwin" system
          then inputs.nixpkgs-darwin
          else nixpkgs
        ) {
          inherit system overlays;
          config.allowUnfree = true;
        }
    );

    # for devShell (unstable has better binary cache coverage)
    devPkgsFor = forEachSystem (
      system:
        import inputs.nixpkgs-unstable {
          inherit system;
        }
    );

    specialArgs = {
      inherit inputs;
      username = "dave";
      name = "David Poole";
      email = "dtpoole@users.noreply.github.com";
    };

    # helper functions
    mkNixosConfiguration = host:
      lib.nixosSystem {
        modules = commonModules ++ [(import ./hosts/${host})];
        inherit specialArgs;
      };

    mkDarwinConfiguration = host:
      nix-darwin.lib.darwinSystem {
        modules = commonDarwinModules ++ [(import ./hosts/${host})];
        inherit specialArgs;
      };

    mkHomeConfiguration = {
      username,
      system,
      host,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        modules = [
          (import ./hosts/${host}/home-manager.nix)
        ];
        extraSpecialArgs = specialArgs // {inherit username;};
      };

    nixosHosts = ["pure" "sparkles" "sapphire"];
    darwinHosts = ["mini" "aurora"];
    homeConfigs = let
      mkConfig = system: host: {
        inherit system host;
        inherit (specialArgs) username;
      };
      extraHomeHosts = [(mkConfig "x86_64-linux" "PF5R9ELQ")];
    in
      extraHomeHosts
      ++ map (mkConfig "x86_64-linux") nixosHosts
      ++ map (mkConfig "aarch64-darwin") darwinHosts;
  in {
    devShells = forEachSystem (system: import ./shell.nix {pkgs = devPkgsFor.${system};});
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = mkNixosConfiguration host;
      })
      nixosHosts);

    darwinConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = mkDarwinConfiguration host;
      })
      darwinHosts);

    homeConfigurations = builtins.listToAttrs (map (cfg: {
        name = "${cfg.username}@${cfg.host}";
        value = mkHomeConfiguration {inherit (cfg) username system host;};
      })
      homeConfigs);
  };
}
