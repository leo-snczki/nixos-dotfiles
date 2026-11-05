{
  # Load a project's devShell on cd (`use flake` in .envrc). nix-direnv caches
  # it and keeps it as a GC root, so the Nix store paths it links survive
  # garbage collection.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
