{
  description = "Make dream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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

      homeConfigurations = {
        "${username}@mini" = hmc "x86_64-darwin";
        "${username}@slippy" = hmc "x86_64-linux";
        "${username}@chacha" = hmc "aarch64-linux";
        "${username}@north" = hmc "x86_64-linux";
        "${username}@PF2N1Y5V" = hmc "x86_64-linux";
      };
    };
}
