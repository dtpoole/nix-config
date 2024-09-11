{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
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

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib.extend (final: prev: {
        inherit (nix-darwin.lib) darwinSystem;
        inherit (home-manager.lib) homeManagerConfiguration;
      });

      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = lib.genAttrs systems;

      pkgsFor = forEachSystem (system: nixpkgs.legacyPackages.${system});

    in
    {

      devShells = forEachSystem (system: import ./shell.nix { pkgs = pkgsFor.${system}; });
      formatter = forEachSystem (system: pkgsFor.${system}.nixpkgs-fmt);

      nixosConfigurations = {
        slug = lib.nixosSystem {
          modules = [ ./hosts/slug ];
          specialArgs = { inherit inputs outputs; };
        };

        supernaut = lib.nixosSystem {
          modules = [ ./hosts/supernaut ];
          specialArgs = { inherit inputs outputs; };
        };

        hope = lib.nixosSystem {
          modules = [ ./hosts/hope ];
          specialArgs = { inherit inputs outputs; };
        };

        jumbo = lib.nixosSystem {
          modules = [ ./hosts/jumbo ];
          specialArgs = { inherit inputs outputs; };
        };

        sparkles = lib.nixosSystem {
          modules = [ ./hosts/sparkles ];
          specialArgs = { inherit inputs outputs; };
        };

        vm1 = lib.nixosSystem {
          modules = [ ./hosts/vm1 ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      darwinConfigurations = {
        mini = lib.darwinSystem {
          modules = [ ./hosts/mini ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "dave@PF2N1Y5V" = lib.homeManagerConfiguration {
          modules = [ ./home/dave ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "dave@north" = lib.homeManagerConfiguration {
          modules = [ ./home/dave ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "dave@soma" = lib.homeManagerConfiguration {
          modules = [ ./home/dave ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "dave@ram" = lib.homeManagerConfiguration {
          modules = [ ./home/dave ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "dave@sapphire" = lib.homeManagerConfiguration {
          modules = [ ./home/dave ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

      };

    };
}
