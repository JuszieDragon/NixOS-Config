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

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nixarr.url = "github:rasmus-kirk/nixarr";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    aagl,
    agenix,
    home-manager,
    my-nixpkgs,
    nix-on-droid,
    nixpkgs-unstable,
    nixarr,
    vscode-server,
    ...
  } @ inputs: 
    with inputs;
    let
      lib = nixpkgs-unstable.lib;
      catalog = import ./catalog.nix { inherit lib; };
      default-modules = system: [
        agenix.nixosModules.default
        nixarr.nixosModules.default
        vscode-server.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users."justin" = ./hosts/${system}/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        ./hosts/${system}/configuration.nix
      ];
    in {
    nixosConfigurations = {
      night-city = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "night-city";

        specialArgs = { inherit inputs catalog; };
      };
      
      soul-matrix = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = default-modules "soul-matrix";

        specialArgs = { inherit inputs catalog; };
      };
    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs-unstable { system = "aarch64-linux"; };
      
      modules = [ ./hosts/comp/configuration.nix ];

      extraSpecialArgs = { inherit inputs; };
    };
  };
}

