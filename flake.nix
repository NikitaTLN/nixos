{
    description = "NixOS-BTW";
    
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprlauncher = {
            url = "github:hyprwm/hyprlauncher";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dgop = {
            url = "github:AvengeMedia/dgop";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dms-cli = {
            url = "github:AvengeMedia/danklinux";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dankMaterialShell = {
            url = "github:AvengeMedia/DankMaterialShell";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.dgop.follows = "dgop";
            inputs.dms-cli.follows = "dms-cli";
        };
        nixcord = {
            url = "github:kaylorben/nixcord";
        };
        helium = {
            url = "github:FKouhai/helium2nix/main";
        };
    };

    outputs = { self, nixpkgs, home-manager, helium, zen-browser, hyprlauncher, dgop, dms-cli, dankMaterialShell, nixcord, ... } @ inputs: {
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
