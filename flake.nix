{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    my-nixpkgs.url = "github:JuszieDragon/nixpkgs";

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
    nixpkgs-unstable,
    nixarr,
    vscode-server,
    ...
  } @ inputs: 
    with inputs;
    let
      lib = nixpkgs-unstable.lib;
      catalog = import ./catalog.nix { inherit lib; };
    in {
    nixosConfigurations = {
      desktop = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.honkers-railway-launcher.enable = true;
          }
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      night-city = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          agenix.nixosModules.default
          nixarr.nixosModules.default
          vscode-server.nixosModules.default
          
          ./hosts/night-city/configuration.nix
        ];

        specialArgs = { 
          inherit inputs catalog;
        };
      };
      
      soul-matrix = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          agenix.nixosModules.default
          nixarr.nixosModules.default
          vscode-server.nixosModules.default
          
          ./hosts/soul-matrix/configuration.nix
        ];

        specialArgs = { 
          inherit inputs catalog;
        };
      };
    };
  };
}
