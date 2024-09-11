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

      mkNixosConfiguration = hostname: nixpkgs.lib.nixosSystem {
        modules = [ (import ./hosts/${hostname}) ];
        specialArgs = { inherit inputs outputs; };
      };

    in
    {

      devShells = forEachSystem (system: import ./shell.nix { pkgs = pkgsFor.${system}; });
      formatter = forEachSystem (system: pkgsFor.${system}.nixpkgs-fmt);

      nixosConfigurations = builtins.listToAttrs (map
        (hostname: { name = hostname; value = mkNixosConfiguration hostname; })
        [ "slug" "supernaut" "hope" "jumbo" "sparkles" "vm1" ]
      );

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
