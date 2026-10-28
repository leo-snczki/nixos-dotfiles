{vars, pkgs, ...}:
{
  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      user.Name = "leo-snczki";
      user.Email = "79675019+leo-snczki@users.noreply.github.com";
      init.defaultBranch = "main";
      credential.helper = "libsecret";
      safety.directory = vars.dataDir;
    };
  };
}
