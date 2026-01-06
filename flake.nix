{
    description = "NixOS-BTW";
    
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        helium = {
            url = "github:FKouhai/helium2nix/main";
        };
        sfpro = {
            url = "github:Lyndeno/apple-fonts.nix";
        };
        nixcord = {
            url = "github:kaylorben/nixcord";
        };
    };

    outputs = { self, nixpkgs, home-manager, nixcord, sfpro, helium, ... } @ inputs: {
        nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.w1dget = import ./home.nix;
                        backupFileExtension = "backup";
                        extraSpecialArgs = { inherit inputs; };
                    };
                }
            ];
        };
    };
}
