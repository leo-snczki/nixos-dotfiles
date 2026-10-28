{vars, pkgs, ...}:
{
  programs.git = {
    enable = true;
    settings = {
      user.Name = "leo-snczki";
      user.Email = "79675019+leo-snczki@users.noreply.github.com";
      init.defaultBranch = "main";
      safety.directory = vars.dataDir;
      pull.rebase = true
    };
  };

  programs.ssh = {
    enable = true;

    matchBlocks."github.com" = {
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
      identitiesOnly = true;
    };
  };
}
