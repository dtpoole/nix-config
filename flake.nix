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

      makeNixos = { host, hasGUI ? true }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username; };
        modules = [
          ./hosts/${host}
          ./modulez/common.nix
          ./modulez/user.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
            home-manager.extraSpecialArgs = { inherit username; };
          }
        ];
      };

      makeHome = { system ? "x86_64-linux", hasGUI ? false }: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = {
          inherit username hasGUI;
        };
        modules = [
          ./home
        ];
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

      nixosConfigurations = {
        nixos = makeNixos { host = "nixos"; };
        slug = makeNixos { host = "slug"; };
      };

      homeConfigurations = {
        "${username}@mini" = makeHome {
          system = "x86_64-darwin";
          hasGUI = true;
        };

        "${username}@chacha" = makeHome {
          system = "aarch64-linux";
        };

        "${username}@slippy" = makeHome {
          system = "x86_64-linux";
        };

        "${username}@north" = makeHome {
          system = "x86_64-linux";
        };

        "${username}@PF2N1Y5V" = makeHome {
          system = "x86_64-linux";
        };
      };

    };
}
