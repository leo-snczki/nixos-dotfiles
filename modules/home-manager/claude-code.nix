{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;

    # Use the native binary from sadjow/claude-code-nix.
    package = pkgs.claude-code;

    # Global instructions: ~/.claude/CLAUDE.md
    context = ''
      # Global instructions

      - Inspect the project before making changes.
      - Prefer simple, maintainable solutions.
      - Follow existing project conventions.
      - Explain destructive operations before executing them.
      - Never expose secrets, tokens, or credentials.
    '';

    # Declarative settings: ~/.claude/settings.json
    settings = {
      theme = "dark";
      includeCoAuthoredBy = false;

      permissions = {
        defaultMode = "default";

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
    skills = { };

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