{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-apple-silicon.follows = "apple-silicon/nixpkgs";

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
      url = "github:epireyn/niri-flake";
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

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kosync = {
      url = "git+https://codeberg.org/cmooon/kosync";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gallery-dl-latest = {
      url = "git+https://codeberg.org/mikf/gallery-dl?ref=refs/tags/v1.32.7";
      flake = false;
    };

    apple-silicon.url = "github:nix-community/nixos-apple-silicon";

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nixpkgs-patch-qbittorrent = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:qbittorrent-categories.diff";
      flake = false;
    };
    nixpkgs-patch-yarr = {
      url = "https://github.com/NixOS/nixpkgs/compare/master...JuszieDragon:nixpkgs:yarr-db-path-and-user.diff";
      flake = false;
    };
    nixpkgs-patch-kavita-groups = {
      url = "https://github.com/NixOS/nixpkgs/pull/456789.diff";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  outputs = {
    agenix,
    apple-silicon,
    gallery-dl-latest,
    home-manager,
    kosync,
    lazyvim,
    niri,
    nix-on-droid,
    nixpkgs,
    nixpkgs-apple-silicon,
    nixpkgs-master,
    nixpkgs-patcher,
    nixarr,
    noctalia-greeter,
    ...
  } @ inputs:
    let
      # for firefox-devedition as mozilla only keeps the latest binary and unstable can lag behind a bit on updating to latest
      pkgs-master = import nixpkgs-master {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      catalog-gen = host: import ./catalog.nix { inherit (nixpkgs) lib; inherit host; };
      default-modules = system: catalog: [
        agenix.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            users."justin" = ./hosts/${system}/home.nix;
            extraSpecialArgs = { inherit inputs catalog pkgs-master; hostname = system; };
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
          nixarr.nixosModules.default
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

      eden = let
        catalog = catalog-gen "eden";
      in nixpkgs-patcher.lib.nixosSystem {
        nixpkgsPatcher = {
          inherit inputs;
          nixpkgs = nixpkgs-apple-silicon;
        };

        system = "aarch64-linux";

	      modules = [
	        apple-silicon.nixosModules.apple-silicon-support
	        niri.nixosModules.niri
          { nixpkgs.overlays = [ niri.overlays.niri ]; }
          noctalia-greeter.nixosModules.default
        ] ++ (default-modules "eden" catalog);

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

