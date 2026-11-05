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

    nixpkgs-firefox.url = "github:nixos/nixpkgs/nixos-unstable";

    # graphify on its own nixpkgs, updated with `nix flake update nixpkgs-graphify`.
    nixpkgs-graphify.url = "github:nixos/nixpkgs/nixos-unstable";

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yt-x = {
      url = "github:leo-snczki/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    viu.url = "github:leo-snczki/viu";

    claude-code.url = "github:sadjow/claude-code-nix";

    ccstatusline.url = "github:numtide/llm-agents.nix";

    agent-browser.url = "github:numtide/llm-agents.nix";

    terminal-browser.url = "github:numtide/llm-agents.nix";

    terminal-use.url = "github:numtide/llm-agents.nix";

    skills.url = "github:numtide/llm-agents.nix";

    git-surgeon.url = "github:numtide/llm-agents.nix";

    pdfvision.url = "github:numtide/llm-agents.nix";

    rtk.url = "github:numtide/llm-agents.nix";

    # Source of the find-skills skill (the skills package ships only the CLI).
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };

    watermarks-remover = {
      url = "github:guillaumemeyer/watermarks-remover";
      flake = false;
    };

    # Claude Code plugin with the karpathy-guidelines skill (no release tags).
    andrej-karpathy-skills = {
      url = "github:multica-ai/andrej-karpathy-skills";
      flake = false;
    };

    # Claude Code plugin with Matt Pocock's engineering skills.
    mattpocock-skills = {
      url = "github:mattpocock/skills/v1.3.2";
      flake = false;
    };

    # token-savior MCP server source (packaged in claude-code.nix).
    token-savior = {
      url = "github:mibayy/token-savior/v4.24.0";
      flake = false;
    };

    nix-craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          inputs.claude-code.overlays.default

          # graphify runs `sys.executable -m graphify` for its workers, git
          # hooks and merge driver, but the nixpkgs wrapper only adds its
          # modules inside its own process. Point sys.executable at a python
          # that has them (graphify-python).
          (final: prev:
            let
              gpkgs = inputs.nixpkgs-graphify.legacyPackages.${system};
              # graphify has no Nix parser and skips .nix files; read them as
              # documents instead (semantic extraction in /graphify).
              base = gpkgs.graphify.overridePythonAttrs (old: {
                postPatch = (old.postPatch or "") + ''
                  substituteInPlace graphify/detect.py \
                    --replace-fail "DOC_EXTENSIONS = {'.md'," "DOC_EXTENSIONS = {'.nix', '.md',"
                '';
              });
            in {
              graphify = prev.symlinkJoin {
                inherit (base) name version meta;
                paths = [ base ];
                nativeBuildInputs = [ prev.makeWrapper ];
                postBuild = ''
                  makeWrapper ${gpkgs.python3}/bin/python $out/bin/graphify-python \
                    --prefix PYTHONPATH : ${base}/${gpkgs.python3.sitePackages}:${gpkgs.python3Packages.makePythonPath base.dependencies} \
                    --set NIX_PYTHONEXECUTABLE $out/bin/graphify-python
                  rm $out/bin/graphify
                  makeWrapper ${base}/bin/graphify $out/bin/graphify \
                    --set NIX_PYTHONEXECUTABLE $out/bin/graphify-python
                '';
              };
            })
        ];
      };
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
        clotilde = home-manager.lib.homeManagerConfiguration {
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

