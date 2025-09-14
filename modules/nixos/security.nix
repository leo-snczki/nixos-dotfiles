{ pkgs, ... }:

{
  xdg = {
    portal = {
      xdgOpenUsePortal = false;
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "polkit_gnome"
            #"gnome-keyring"
          ];
        };
      };
    };
  };

  security = {
    pam.services.sddm.enableGnomeKeyring = true;
    rtkit.enable = true;
    polkit.enable = true;
    # pam.services.lightdm.kwallet.enable = true;
    # pam.services.sddm.enableKwallet = true;
    # pam.services.sddm.kwallet.package = pkgs.kdePackages.kwallet-pam;

    #  pam.services.kwallet = { # if no display manager
    #    name = "kwallet";
    #    enableKwallet = true;
    #  };
  };

  programs.seahorse.enable = true; # Keyring program
  services.gnome = {
    #    gnome-settings-daemon.enable = true;
    gnome-keyring.enable = true;
  };

  # systemd = {
  #   user.services.polkit-kwallet-authentication-agent-1 = {
  #     description = "polkit-kwallet-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #      Type = "simple";
  #       ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #    };
  #   };
  # }; 

  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
  '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';
}
