{vars, pkgs, ...}:
{
  programs.git = {
    enable = true;
    settings = {
      user.Name = "leo-snczki";
      user.Email = "79675019+leo-snczki@users.noreply.github.com";
      init.defaultBranch = "main";
      safety.directory = vars.dataDir;
    };
  };
}
