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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, agenix, ... }@inputs:
    let

      username = "dave";

      inherit (nixpkgs.lib.strings) hasSuffix;

      makeSystem = { host, system ? "x86_64-linux", hasGUI ? false }:

        let
          isDarwin = if hasSuffix "darwin" system then true else false;
          isLinux = if hasSuffix "linux" system then true else false;
          systemFunc = if isDarwin then nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
          home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
        in
        systemFunc rec {
          specialArgs = { inherit inputs system username agenix host; };
          modules = [
            ./hosts/${host}
            (if isLinux then ./modulez/common.nix else { })
            (if isLinux then ./modulez/user.nix else { })

            { _module.args = { unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; }; }
            (if isDarwin then agenix.darwinModules.default else agenix.nixosModules.default)

            home-manager.home-manager
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
        slug = makeSystem { host = "slug"; system = "x86_64-linux"; hasGUI = true; };
        crunch = makeSystem { host = "crunch"; };
        orion = makeSystem { host = "orion"; };
        fuzzmo = makeSystem { host = "fuzzmo"; };
      };

      darwinConfigurations = {
        mini = makeSystem { host = "mini"; system = "x86_64-darwin"; hasGUI = true; };
      };

      homeConfigurations = {
        "${username}@north" = makeHome { };
        "${username}@PF2N1Y5V" = makeHome { };
      };

    };
}
