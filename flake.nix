{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
	    url = "github:ryantm/agenix";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nixarr.url = "github:rasmus-kirk/nixarr";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    nixpkgs,
    nixarr,
    home-manager,
    aagl,
    vscode-server,
    agenix,
    ...
  } @ inputs: 
    with inputs;
    let
      catalog = import ./catalog.nix { inherit lib; };
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
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

      night-city = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/night-city/configuration.nix
	        agenix.nixosModules.default
          nixarr.nixosModules.default
          vscode-server.nixosModules.default
        ];

        specialArgs = { 
          inherit inputs;
          inherit catalog;
        };
      };
    };
  };
}
