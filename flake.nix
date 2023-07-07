{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:

    let
      inherit (self) outputs;

      username = "dave";

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      hmc = system: home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs outputs username; };
        modules = [ ./home ];
        pkgs = nixpkgs.legacyPackages."${system}";
      };

    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { system = system; };
        in
        import ./shell.nix { inherit pkgs; }
      );

      # 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ 
            ./hosts/nixos/configuration.nix 
            ./home/nixos.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home;
            }
          ];
        };
      };

      # 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "${username}@mini" = hmc "x86_64-darwin";
        "${username}@nixos" = hmc "x86_64-linux";
        "${username}@slippy" = hmc "x86_64-linux";
        "${username}@chacha" = hmc "aarch64-linux";
        "${username}@north" = hmc "x86_64-linux";
        "${username}@PF2N1Y5V" = hmc "x86_64-linux";
      };
    };
}
