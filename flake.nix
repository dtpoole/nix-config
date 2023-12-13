{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, agenix, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs.lib.strings) hasSuffix;

      lib = nix-darwin.lib // nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        overlays = [
          outputs.overlays.additions
        ];
        config.allowUnfree = true;
      });

      username = "dave";

      makeSystem = { host, system ? "x86_64-linux", hasGUI ? false }:

        let
          isDarwin = if hasSuffix "darwin" system then true else false;
          isLinux = if hasSuffix "linux" system then true else false;
          systemFunc = if isDarwin then nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
          home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
        in
        systemFunc rec {
          specialArgs = { inherit inputs outputs system username agenix host; };
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

      makeHome = { system ? "x86_64-linux", hasGUI ? false }: lib.homeManagerConfiguration {

        # pkgs = pkgsFor.${system};
        # extraSpecialArgs = { inherit inputs outputs username hasGUI; };
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = {
          inherit inputs outputs username hasGUI;
        };
        modules = [
          ./home
        ];
      };



    in
    {
      overlays = import ./overlays { inherit inputs outputs; };
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      unstablePkgs = forAllSystems (system: import ./pkgs nixpkgs-unstable.legacyPackages.${system});

      nixosConfigurations = {
        slug = makeSystem { host = "slug"; system = "x86_64-linux"; hasGUI = true; };
        crunch = makeSystem { host = "crunch"; };
        # supernaut = makeSystem { host = "supernaut"; };

        supernaut = lib.nixosSystem {
          modules = [ ./hosts/supernaut ];
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
        # "${username}@north" = makeHome { };
        "${username}@PF2N1Y5V" = makeHome { };


        "dave@north" = lib.homeManagerConfiguration {
          modules = [ ./home ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        # "dave@mini" = lib.homeManagerConfiguration {
        #   modules = [ ./home ];
        #   pkgs = pkgsFor.x86_64-darwin;
        #   extraSpecialArgs = { inherit inputs outputs; };
        # };

      };

    };
}
