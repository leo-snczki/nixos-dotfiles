{
  description = "flake for NixOs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yt-x = {
      url = "github:leo-snczki/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };


  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      vars = rec {
        app = "nameofproject";
        dataDir = "/var/www/htdocs/site/${app}";
      };
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
        specialArgs = {
          # Make flake inputs available in NixOS modules.
          inherit inputs;
          inherit system;
          inherit vars;
        };
      };

      homeConfigurations = {
        rambo = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            # Make flake inputs available in Home-manager modules.
            inherit self inputs vars;
          };
        };
      };
    };
}

