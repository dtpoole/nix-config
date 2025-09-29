{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
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

    commonModules = [
      {nixpkgs.overlays = overlays;}
      inputs.agenix.nixosModules.default
    ];

    commonDarwinModules = [
      {nixpkgs.overlays = overlays;}
      inputs.agenix.darwinModules.default
    ];

    # for devShell/standalone home manager
    pkgsFor = forEachSystem (
      system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
    );

    specialArgs = {inherit inputs;};

    # helper functions
    mkNixosConfiguration = hostname:
      nixpkgs.lib.nixosSystem {
        modules = commonModules ++ [(import ./hosts/${hostname})];
        inherit specialArgs;
      };

    mkDarwinConfiguration = hostname:
      nix-darwin.lib.darwinSystem {
        modules = commonDarwinModules ++ [(import ./hosts/${hostname})];
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
        username = "dave";
      };
    in [
      (mkConfig "x86_64-linux" "PF5R9ELQ")
      (mkConfig "aarch64-darwin" "mini")
      (mkConfig "aarch64-darwin" "aurora")
      (mkConfig "x86_64-linux" "pure")
      (mkConfig "x86_64-linux" "sparkles")
      (mkConfig "x86_64-linux" "sapphire")
    ];
  in {
    devShells = forEachSystem (system: import ./shell.nix {pkgs = pkgsFor.${system};});
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
