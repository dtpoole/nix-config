# This function creates a nix-darwin system.
name: { nixpkgs, home-manager, system, username }:

system: home-manager.lib.homeManagerConfiguration rec {
    extraSpecialArgs = { inherit inputs outputs username; };
    modules = [ ./home ];
    pkgs = nixpkgs.legacyPackages."${system}";
};
