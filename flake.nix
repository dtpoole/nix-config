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

      mkHomeConfig = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = { inherit username; };
        modules = [ ./home ];
      };

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

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
          specialArgs = { inherit inputs username; };
          modules = [
            ./hosts/nixos/configuration.nix
            ./home/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = { inherit inputs outputs username; };
            }
          ];
        };
      };

      # 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "${username}@mini" = mkHomeConfig "x86_64-darwin";
        "${username}@slippy" = mkHomeConfig "x86_64-linux";
        "${username}@chacha" = mkHomeConfig "aarch64-linux";
        "${username}@north" = mkHomeConfig "x86_64-linux";
        "${username}@PF2N1Y5V" = mkHomeConfig "x86_64-linux";
      };

    };
}
