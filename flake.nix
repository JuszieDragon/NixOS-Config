{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    dotfiles = {
      url = "git+ssh://git@github.com/JuszieDragon/dotfiles.git";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr.url = "github:rasmus-kirk/nixarr";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nixpkgs-patch-qbit-and-yarr = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:yarr.diff";
      flake = false;
    };
    # https://github.com/NixOS/nixpkgs/pull/472163
    nixpkgs-patch-xone-dongle-drivers = {
      url = "https://github.com/NixOS/nixpkgs/pull/472163.diff";
      flake = false;
    };
    nixpkgs-patch-vesktop-permission-fix = {
      url = "https://github.com/NixOS/nixpkgs/pull/476347.diff";
      flake = false;
    };
  };

  outputs = {
    self,
    agenix,
    home-manager,
    niri,
    nix-on-droid,
    nixpkgs,
    nixpkgs-patcher,
    nixarr,
    ...
  } @ inputs: 
    let
      lib = nixpkgs.lib;
      catalog-gen = host: import ./catalog.nix { inherit lib host; };
      default-modules = system: catalog: [
        agenix.nixosModules.default
        nixarr.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users."justin" = ./hosts/${system}/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs catalog; };
        }

        ./hosts/${system}/configuration.nix
      ];
    in {
    nixosConfigurations = {
      night-city = let 
        catalog = catalog-gen "night-city"; 
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "night-city" catalog;

        specialArgs = { inherit inputs catalog; };
      };
      
      soul-matrix = let
        catalog = catalog-gen "soul-matrix";
      in nixpkgs-patcher.lib.nixosSystem {
        nixpkgsPatcher.inputs = inputs;

        system = "x86_64-linux";

        modules = default-modules "soul-matrix" catalog;

        specialArgs = { inherit inputs catalog; };
      };

      last-defence-academy = let 
        catalog = catalog-gen "last-defence-academy"; 
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "last-defence-academy" catalog;

        specialArgs = { inherit inputs catalog; };
      };

      revachol = let
        catalog = catalog-gen "revachol";
      in nixpkgs-patcher.lib.nixosSystem {
        nixpkgsPatcher.inputs = inputs;
        
        system = "x86_64-linux";

        modules = [ 
          niri.nixosModules.niri
          { nixpkgs.overlays = [ niri.overlays.niri ]; }
        ] ++ (default-modules "revachol" catalog);
        
        specialArgs = { inherit inputs catalog; };
      };
    };

    nixOnDroidConfigurations.default = let
      catalog = catalog-gen "yes";
    in nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      
      modules = [ ./hosts/comp/configuration.nix ];

      extraSpecialArgs = { inherit inputs catalog; };
    };
  };
}

