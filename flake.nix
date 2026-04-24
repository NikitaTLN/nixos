{
    description = "NixOS-BTW";
    
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        oxwm = {
          url = "github:tonybanters/oxwm";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        sfpro = {
            url = "github:Lyndeno/apple-fonts.nix";
        };
    };

    outputs = { self, nixpkgs, home-manager, sfpro, oxwm, ... } @ inputs: {
        nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                oxwm.nixosModules.default
                {
                  services.xserver.windowManager.oxwm.enable = true;
                }
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
