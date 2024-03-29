{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      inherit (self) outputs;

      lib = nix-darwin.lib // nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        overlays = [
          outputs.overlays.additions
        ];
        config.allowUnfree = true;
      });

    in
    {
      overlays = import ./overlays { inherit inputs outputs; };
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      nixosConfigurations = {
        slug = lib.nixosSystem {
          modules = [ ./hosts/slug ];
          specialArgs = { inherit inputs outputs; };
        };

        crunch = lib.nixosSystem {
          modules = [ ./hosts/crunch ];
          specialArgs = { inherit inputs outputs; };
        };

        supernaut = lib.nixosSystem {
          modules = [ ./hosts/supernaut ];
          specialArgs = { inherit inputs outputs; };
        };

        vm1 = lib.nixosSystem {
          modules = [ ./hosts/vm1 ];
          specialArgs = { inherit inputs outputs; };
        };

        bombs = lib.nixosSystem {
          modules = [ ./hosts/bombs ];
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
      };

    };
}
