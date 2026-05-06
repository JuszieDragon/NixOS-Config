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

    sqlit = {
      url = "github:Maxteabag/sqlit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kosync = {
      url = "git+https://codeberg.org/cmooon/kosync";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Use https://nixpkgs-tracker.ocfox.me/?pr=<prNum> to check if patch is still needed
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nixpkgs-patch-qbittorrent = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:qbittorrent-categories.diff";
      flake = false;
    };
    nixpkgs-patch-yarr = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:yarr-db-path-and-user.diff";
      flake = false;
    };
    # https://github.com/NixOS/nixpkgs/pull/472163
    #nixpkgs-patch-xone-dongle-drivers = {
    #  url = "https://github.com/NixOS/nixpkgs/pull/472163.diff";
    #  flake = false;
    #};
    nixpkgs-patch-kavita-groups = {
      url = "https://github.com/NixOS/nixpkgs/pull/456789.diff";
      flake = false;
    };
    nixpkgs-patch-cage-0-3-0 = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:cage-0.3.0.diff";
      flake = false;
    };
  };

  outputs = {
    agenix,
    home-manager,
    kosync,
    lazyvim,
    niri,
    nix-on-droid,
    nixpkgs,
    nixpkgs-patcher,
    nixarr,
    ...
  } @ inputs: 
    let
      catalog-gen = host: import ./catalog.nix { inherit (nixpkgs) lib; inherit host; };
      default-modules = system: catalog: [
        agenix.nixosModules.default
        nixarr.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            users."justin" = ./hosts/${system}/home.nix;
            extraSpecialArgs = { inherit inputs catalog; };
          };
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
      in nixpkgs-patcher.lib.nixosSystem rec {
        nixpkgsPatcher.inputs = inputs;

        system = "x86_64-linux";

        modules = [
          kosync.nixosModules.${system}.default
        ] ++ default-modules "soul-matrix" catalog;

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

