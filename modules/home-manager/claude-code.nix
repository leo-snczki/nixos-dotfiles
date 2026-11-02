{ config, pkgs, inputs, ... }:

let
  # ccstatusline from numtide/llm-agents.nix (not packaged in nixpkgs).
  ccstatusline = inputs.ccstatusline.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline;

  # Agent tools, also from numtide/llm-agents.nix. Separate inputs per tool so
  # each can be updated on its own (`nix flake update <tool>`).
  agent-browser = inputs.agent-browser.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser;
  terminal-browser = inputs.terminal-browser.packages.${pkgs.stdenv.hostPlatform.system}.terminal-browser;
  terminal-use = inputs.terminal-use.packages.${pkgs.stdenv.hostPlatform.system}.terminal-use;
  skills = inputs.skills.packages.${pkgs.stdenv.hostPlatform.system}.skills;
in
{
  home.packages = [
    ccstatusline
    agent-browser
    terminal-browser
    terminal-use
    skills
  ];

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
    hooks = { };

    # Custom skills: ~/.claude/skills/
    # Each skill is linked on its own, so ~/.claude/skills stays writable
    # for `skills add -g -a claude-code`.
    skills = {
      agent-browser = "${agent-browser}/share/agent-browser/skills/agent-browser";
      terminal-browser = "${terminal-browser}/lib/terminal-browser/skills/default/terminal-browser";
      find-skills = "${inputs.vercel-skills}/skills/find-skills";
    };

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
    };
  };
}