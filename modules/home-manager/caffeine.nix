{ pkgs, ... }:

# services.caffeine.enable is broken

{
  systemd.user.services.caffeine = {
    Unit = {
      Description = "Caffeine NG keep-awake service (X11)";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}