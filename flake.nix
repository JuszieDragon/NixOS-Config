{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    my-nixpkgs.url = "github:JuszieDragon/nixpkgs/yarr";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    dotfiles = {
      url = "git+ssh://git@github.com/JuszieDragon/dotfiles.git";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixarr.url = "github:rasmus-kirk/nixarr";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    agenix,
    home-manager,
    my-nixpkgs,
    niri,
    nix-on-droid,
    nixpkgs-unstable,
    nixarr,
    ...
  } @ inputs: 
    with inputs;
    let
      lib = nixpkgs-unstable.lib;
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
      in nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "night-city" catalog;

        specialArgs = { inherit inputs catalog; };
      };
      
      soul-matrix = let
        catalog = catalog-gen "soul-matrix";
      in nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "soul-matrix" catalog;

        specialArgs = { inherit inputs catalog; };
      };

      last-defence-academy = let 
        catalog = catalog-gen "last-defence-academy"; 
      in nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "last-defence-academy" catalog;

        specialArgs = { inherit inputs catalog; };
      };

      revachol = let
        catalog = catalog-gen "revachol";
      in nixpkgs-unstable.lib.nixosSystem {
        system = "x86_65-linux";

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
      pkgs = import nixpkgs-unstable { system = "aarch64-linux"; };
      
      modules = [ ./hosts/comp/configuration.nix ];

      extraSpecialArgs = { inherit inputs catalog; };
    };
  };
}

