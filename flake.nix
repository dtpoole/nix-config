{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, ... }:

    let
      inherit (self) outputs;

      username = "dave";

      makeNixos = { host, system ? "x86_64-linux", hasGUI ? true }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username host; };
        modules = [
          ./hosts/${host}
          ./modulez/common.nix
          ./modulez/user.nix

          { _module.args = { unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; }; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
            home-manager.extraSpecialArgs = { inherit username hasGUI; };
          }
        ];
      };

      makeDarwin = { host, system ? "x86_64-darwin", hasGUI ? true }: nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs username system; };
        modules = [
          ./hosts/${host}

          { _module.args = { unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; }; }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
            home-manager.extraSpecialArgs = { inherit username hasGUI; };
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

      darwinConfigurations = {
        mini = makeDarwin { host = "mini"; system = "x86_64-darwin"; };
      };

      homeConfigurations = {
        "${username}@chacha" = makeHome {
          system = "aarch64-linux";
        };

        "${username}@slippy" = makeHome { };
        "${username}@north" = makeHome { };
        "${username}@PF2N1Y5V" = makeHome { };
      };

    };
}
