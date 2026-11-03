{ config, lib, pkgs, inputs, ... }:

let
  # ccstatusline from numtide/llm-agents.nix (not packaged in nixpkgs).
  ccstatusline = inputs.ccstatusline.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline;

  # Agent tools, also from numtide/llm-agents.nix. Separate inputs per tool so
  # each can be updated on its own (`nix flake update <tool>`).
  agent-browser = inputs.agent-browser.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser;
  terminal-browser = inputs.terminal-browser.packages.${pkgs.stdenv.hostPlatform.system}.terminal-browser;
  terminal-use = inputs.terminal-use.packages.${pkgs.stdenv.hostPlatform.system}.terminal-use;
  skills = inputs.skills.packages.${pkgs.stdenv.hostPlatform.system}.skills;
  git-surgeon = inputs.git-surgeon.packages.${pkgs.stdenv.hostPlatform.system}.git-surgeon;
  pdfvision = inputs.pdfvision.packages.${pkgs.stdenv.hostPlatform.system}.pdfvision;

  # rtk rewrites Bash commands through a PreToolUse hook so their output is
  # condensed before it reaches Claude. RTK.md is the short awareness file
  # `rtk init -g` writes next to CLAUDE.md; generate it from the same binary.
  rtk = inputs.rtk.packages.${pkgs.stdenv.hostPlatform.system}.rtk;
  rtk-md = pkgs.runCommand "RTK.md" { } ''
    export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR/.config
    mkdir -p $HOME/.claude
    ${rtk}/bin/rtk init -g --no-patch > /dev/null
    cp $HOME/.claude/RTK.md $out
  '';

  # token-savior MCP server (mibayy/token-savior): structural code navigation
  # and persistent memory, to spend fewer tokens reading code. Not in nixpkgs,
  # nor are its tree-sitter Java/Ruby grammar bindings (built from GitHub:
  # the PyPI sdists lack tree_sitter/parser.h).
  py = pkgs.python3Packages;
  treeSitterGrammar =
    pname: version: hash:
    py.buildPythonPackage {
      inherit pname version;
      pyproject = true;
      src = pkgs.fetchFromGitHub {
        owner = "tree-sitter";
        repo = pname;
        tag = "v${version}";
        inherit hash;
      };
      build-system = [ py.setuptools ];
    };
  token-savior = py.buildPythonApplication {
    pname = "token-savior-recall";
    version = "4.24.0";
    pyproject = true;
    src = inputs.token-savior;
    build-system = [ py.hatchling ];
    dependencies = [
      py.mcp
      py.pyyaml
      py.tree-sitter
      py.watchfiles
      (treeSitterGrammar "tree-sitter-java" "0.23.5" "sha256-OvEO1BLZLjP3jt4gar18kiXderksFKO0WFXDQqGLRIY=")
      (treeSitterGrammar "tree-sitter-ruby" "0.23.1" "sha256-iu3MVJl0Qr/Ba+aOttmEzMiVY6EouGi5wGOx5ofROzA=")
    ];
  };

  # REA (morluto/rea) lets Claude reverse engineer shipped artifacts: native
  # binaries, Electron/JS apps, packages, firmware and web apps. It comes in two
  # parts that are both needed: the reverse-engineer-anything skill tells Claude
  # when and how to investigate, and the rea MCP server provides the actual
  # tools (decompile, inspect, compare versions, observe runtime behaviour).
  #
  # rea-agents (the MCP server) is not in nixpkgs; npx runs the release that
  # matches the pinned skill source. Runs on the current Node LTS.
  reaVersion = (lib.importJSON "${inputs.rea}/package.json").version;
  # rea's scripts use `#!/usr/bin/env node`, so node must be on PATH.
  rea-mcp = pkgs.writeShellScript "rea-mcp" ''
    export PATH=${pkgs.nodejs_26}/bin:$PATH
    exec npx -y rea-agents@${reaVersion} mcp "$@"
  '';

  # watermarks-remover plugin (guillaumemeyer/watermarks-remover), unchanged
  # except for hooks/hooks.json: its hook is registered in `hooks` below
  # instead, so it doesn't need Node.
  watermarks-remover = pkgs.runCommand "watermarks-remover-plugin" { } ''
    cp -r ${inputs.watermarks-remover} $out
    chmod -R u+w $out
    rm $out/hooks/hooks.json
  '';
in
{
  home.packages = [
    ccstatusline
    agent-browser
    terminal-browser
    terminal-use
    skills
    git-surgeon
    pdfvision
    rtk
  ];

  home.file.".claude/RTK.md".source = rtk-md;

  # ccstatusline widgets/theme from the config/ccstatusline submodule.
  xdg.configFile."ccstatusline".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/ccstatusline";

  programs.claude-code = {
    enable = true;

    # Use the native binary from sadjow/claude-code-nix.
    package = pkgs.claude-code;

    # Merge servers from programs.mcp.servers (e.g. craftapps) into mcpServers.
    enableMcpIntegration = true;

    # Global instructions: ~/.claude/CLAUDE.md
    context = ''
      # Global instructions

      - Inspect the project before making changes.
      - Prefer simple, maintainable solutions.
      - Follow existing project conventions.
      - Explain destructive operations before executing them.
      - Never expose secrets, tokens, or credentials.

      # terminal-use (`tu`)

      Some programs (htop, vim, mc, dialog-based installers, ncurses UIs) need a
      real terminal to render their interface — you can't just pipe stdin/stdout.
      Use `tu` to run them in a virtual terminal, screenshot the screen, send
      keystrokes, and drive the mouse. Run `tu usage` before the first
      interaction for the full command reference.

      # Skills

      Skills declared in modules/home-manager/claude-code.nix and artcraft.nix
      are listed below. ~/.claude/skills stays writable, so there may also be
      skills installed outside the Nix config (with `skills add -g`, synced or
      by plugins): check the available skills list or run `skills list` before
      assuming a skill is missing. Load skills with the Skill tool when the
      task fits:

      - `git-surgeon`: hunk-level staging, commit splitting, folding, squashing,
        rewording and reordering, all non-interactive. Prefer it over
        `git rebase -i` / `git add -p`. Write commit messages in English,
        following Conventional Commits (`type(scope): summary`, max 72 chars).
        Before rewriting history, create a backup branch and check the tree is
        unchanged afterwards; leave force-pushes to the user.
      - `find-skills`: search the skills ecosystem. `npx` is not installed: use
        the `skills` CLI from Nix (`skills find <query>`) instead of
        `npx skills`. To try a skill without installing it, read its SKILL.md
        from GitHub or use `skills use <owner/repo>@<skill>`. To keep one, add
        it declaratively here (flake input + `programs.claude-code.skills`)
        rather than with `skills add`.
      - `pdfvision`: extract text, metadata and page images from PDFs to read
        them (the `pdfvision` CLI). For editing PDFs, use `craftapps` (PdfCraft).
      - `reverse-engineer-anything`: reverse engineer binaries, packaged and
        Electron/JS apps, firmware and web apps when the answer depends on the
        shipped artifact rather than source code (how a closed app works,
        what changed between versions, decompiling). The skill gives the
        workflow; the `rea` MCP server gives the tools, so use both together.
        Skip it for ordinary source-repository analysis.
      - `logo-design`: design, critique and deliver logos as SVG, with a
        searchable library of reference logos and Python audit/export scripts.
      - `karpathy-guidelines` (andrej-karpathy-skills plugin): guidelines
        against common LLM coding mistakes (think first, keep it simple, make
        surgical changes, verify against clear goals). Use when writing,
        reviewing or refactoring code.
      - `replica-*` (replica-skill plugin): clone an app end to end — recon,
        architecture, design, build, backend, tests, parity diff, user-review
        analysis, rebranding, launch listing and deploy. Use when the user
        wants to rebuild an existing app as their own product.
      - `mattpocock-skills` plugin: engineering workflows (grilling a plan,
        spec and ticket flows, TDD, diagnosing bugs, code review, domain
        modelling, handoffs). Use the one that matches the task.
      - `agent-browser`: browser automation (navigate, fill forms, click,
        screenshot, scrape) and Electron apps.
      - `terminal-browser`: show a website or rendered HTML in a split of the
        user's terminal and drive it.
      - `craftapps`: create or edit documents, spreadsheets, slides, PDFs,
        images, vectors, CAD, video and audio with the Craft apps (MCP servers).

      # System

      - NixOS unstable (26.11, `nixos-unstable`), configured with flakes from
        ~/.dotfiles (system config in configuration.nix, entry point flake.nix).
      - Home Manager runs standalone (not as a NixOS module), on the same flake:
        user config in home.nix and modules/home-manager/, applied with
        `home-manager switch --flake ~/.dotfiles`.
      - Prefer Home Manager for user-level changes; touch the NixOS config only
        for system-level ones. Never edit generated files under ~/.claude or
        ~/.config directly; change the Nix source instead.

      # Bash aliases

      The user's shell aliases (from modules/home-manager/bash.nix in
      ~/.dotfiles) for rebuilding the system:

      - `bshm`  → `home-manager switch --flake ~/.dotfiles`
      - `bsnix` → `sudo nixos-rebuild switch --flake ~/.dotfiles`
      - `bbnix` → `sudo nixos-rebuild boot --flake ~/.dotfiles`
      - `btnix` → `sudo nixos-rebuild test --flake ~/.dotfiles`

      Aliases are not expanded in the non-interactive Bash tool, so run the full
      command instead. The `sudo` ones need the user's password: ask the user to
      run them (e.g. `! sudo nixos-rebuild switch --flake ~/.dotfiles`) rather
      than running them yourself. When the user mentions an alias, read it as
      the command above.

      @RTK.md
    '';

    # Declarative settings: ~/.claude/settings.json
    settings = {
      theme = "dark";

      statusLine = {
        type = "command";
        command = "${ccstatusline}/bin/ccstatusline";
        padding = 0;
      };
      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      };

      hooks.PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "${rtk}/bin/rtk hook claude";
            }
          ];
        }
      ];

      hooks.PostToolUse = [
        {
          matcher = "Write|Edit|MultiEdit|NotebookEdit";
          hooks = [
            {
              type = "command";
              command = "${config.programs.claude-code.configDir}/hooks/watermarks-remover";
              timeout = 30;
            }
          ];
        }
      ];

      permissions = {
        defaultMode = "auto";

        deny = [
          "Read(.env)"
          "Read(.env.*)"
          "Read(**/secrets/**)"
        ];
      };
    };

    # Custom agents: ~/.claude/agents/
    agents = {
      nix-reviewer = ''
        ---
        name: nix-reviewer
        description: Review Nix, NixOS, and Home Manager configurations.
        tools: Read, Grep, Glob
        ---

        Review Nix expressions for correctness, reproducibility,
        maintainability, and idiomatic use of Nix.

        Check option names and module structure. Suggest minimal
        changes and explain why they are needed.
      '';
    };

    # Custom slash commands: ~/.claude/commands/
    commands = {
      check-nix = ''
        ---
        description: Review the current Nix configuration
        ---

        Inspect the relevant Nix files and identify likely
        evaluation errors, missing inputs, and configuration issues.
        Suggest commands to validate the changes.
      '';
    };

    # Custom hooks: ~/.claude/hooks/
    hooks = {
      # watermarks-remover PostToolUse hook: strips invisible Unicode (Layer A)
      # and other provenance marks from files Claude writes, in place, and
      # reports each cleanup. The plugin's run_hook.js only picks a Python 3.10+
      # interpreter, so call the script directly.
      watermarks-remover = ''
        #!${pkgs.runtimeShell}
        exec ${pkgs.python3}/bin/python3 ${watermarks-remover}/service/scripts/hook_written_file.py --mode clean "$@"
      '';
    };

    # Plugins: ~/.claude/skills/<name>, loaded as personal plugins.
    plugins = {
      inherit watermarks-remover;
    };

    # Custom skills: ~/.claude/skills/
    # Each skill is linked on its own, so ~/.claude/skills stays writable
    # for `skills add -g -a claude-code`.
    skills = {
      agent-browser = "${agent-browser}/share/agent-browser/skills/agent-browser";
      terminal-browser = "${terminal-browser}/lib/terminal-browser/skills/default/terminal-browser";
      find-skills = "${inputs.vercel-skills}/skills/find-skills";
      git-surgeon = "${git-surgeon}/share/skills/git-surgeon/git-surgeon";
      # The package ships only the CLI; take the skill from the same source.
      pdfvision = "${pdfvision.src}/skills/pdfvision";
      # Workflow for the rea MCP server below (see the REA note at the top).
      reverse-engineer-anything = "${inputs.rea}/.agents/skills/reverse-engineer-anything";
      logo-design = "${inputs.logo-design-skill}/skills/logo-design";

      # Whole plugin repos, linked as real directories so Claude Code loads them
      # as plugins. (The `plugins` option links each top-level entry as a
      # symlink, and the skill paths these plugins list in plugin.json can't
      # go through one.)
      andrej-karpathy-skills = "${inputs.andrej-karpathy-skills}";
      mattpocock-skills = "${inputs.mattpocock-skills}";
    }
    # replica-skill keeps its skills at the repo root ("skills": "./"), which a
    # plugin in ~/.claude/skills doesn't load, so link each skill on its own.
    // lib.genAttrs (lib.attrNames (
      lib.filterAttrs (
        name: type: type == "directory" && builtins.pathExists "${inputs.replica-skill}/${name}/SKILL.md"
      ) (builtins.readDir inputs.replica-skill)
    )) (name: "${inputs.replica-skill}/${name}");

    # MCP servers: leave empty until you have servers to configure.
    mcpServers = { 
      nixos = {
        type = "stdio";
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
          "--"
        ];
      };

      # Reverse-engineering tools used by the reverse-engineer-anything skill.
      rea = {
        type = "stdio";
        command = "${rea-mcp}";
      };

      # Indexes the current directory (WORKSPACE_ROOTS defaults to it).
      token-savior = {
        type = "stdio";
        command = "${token-savior}/bin/token-savior";
        env = {
          TOKEN_SAVIOR_CLIENT = "claude-code";
          TOKEN_SAVIOR_PROFILE = "optimized";
        };
        # Load its tools up front instead of deferring them (upstream advice).
        alwaysLoad = true;
      };
    };
  };
}