{
    description = "NixOS-BTW";
    
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
#        zen-browser = {
#            url = "github:0xc000022070/zen-browser-flake";
#            inputs.nixpkgs.follows = "nixpkgs";
#        };
    };

    outputs = { self, nixpkgs, home-manager, ... }: {
        nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.w1dget = import ./home.nix;
                        backupFileExtension = "backup";
                    };
                }
            ];
        };
    };
}
