{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
  let
    system = "x86_64-linux";
    identity = {
      username = "eden";
      host = "laptop";
      email = "edenkras@gmail.com";
    };
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "${identity.username}@${identity.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system identity; };
        modules = [
          ./nixos-config/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs identity; };
              users.${identity.username} = import ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  };
}
