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
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;

    lib = nixpkgs.lib.extend (final: prev: {
      inherit (home-manager.lib) homeManagerConfiguration;

      lazyAttrs = f: names:
        builtins.listToAttrs (map (name: {
            inherit name;
            value = f name;
          })
          names);
    });

    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = lib.genAttrs systems;

    overlays = [(import ./overlays {inherit inputs;})];

    commonModules = {
      nixos = [
        {nixpkgs.overlays = overlays;}
      ];
      darwin = [
        {nixpkgs.overlays = overlays;}
      ];
    };

    # for devShell/standalone home manager
    pkgsFor = forEachSystem (
      system:
        import nixpkgs {
          inherit system;
        }
    );

    specialArgs = {inherit inputs outputs;};

    # helper functions
    mkNixosConfiguration = hostname: let
      hostConfig = import ./hosts/${hostname};
    in
      nixpkgs.lib.nixosSystem {
        modules = commonModules.nixos ++ [hostConfig];
        inherit specialArgs;
      };

    mkDarwinConfiguration = hostname: let
      hostConfig = import ./hosts/${hostname};
    in
      nix-darwin.lib.darwinSystem {
        modules = commonModules.darwin ++ [hostConfig];
        inherit specialArgs;
      };

    mkHomeConfiguration = {
      username,
      system,
    }: let
      homeConfig = import ./modules/home-manager;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        modules = [homeConfig];
        extraSpecialArgs = specialArgs // {inherit username;};
      };

    nixosHosts = ["jumbo" "pure" "sparkles" "vm1" "sapphire"];
    darwinHosts = ["mini" "aurora"];

    homeConfigs = [
      {
        username = "dave";
        system = "x86_64-linux";
        host = "PF2N1Y5V";
      }
      {
        username = "dave";
        system = "x86_64-linux";
        host = "PF5R9ELQ";
      }
    ];
  in {
    devShells = forEachSystem (system: import ./shell.nix {pkgs = pkgsFor.${system};});
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    nixosConfigurations = lib.lazyAttrs mkNixosConfiguration nixosHosts;
    darwinConfigurations = lib.lazyAttrs mkDarwinConfiguration darwinHosts;

    homeConfigurations = builtins.listToAttrs (map (cfg: {
        name = "${cfg.username}@${cfg.host}";
        value = mkHomeConfiguration {
          inherit (cfg) username system;
        };
      })
      homeConfigs);
  };
}
