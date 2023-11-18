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
    extraArgs = {
      stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      identity = {
        username = "eden";
        host = "laptop";
        email = "edenkras@gmail.com";
      };
    };
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild switch --flake .#your-hostname'
    nixosConfigurations = {
      "${identity.username}@${identity.host}" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system extraArgs; };
        modules = [
          ./nixos-config/common/configuration.nix
          ./nixos-config/"${identity.username}-${identity.host}.nix"
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs extraArgs; };
              users.${identity.username} = import ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  };
}
