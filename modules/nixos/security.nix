
{ pkgs, ... }:

{
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.seahorse.enable = true;

  security.pam.services.sddm.enableGnomeKeyring = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    config.common = {
      default = [ "gtk" ];

      "org.freedesktop.impl.portal.Secret" = [
        "gnome-keyring"
      ];
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
  '';

  # Permitir reboot e power-off sem autenticação
  # aos membros do grupo "users".
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users") &&
        (
          action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
          action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.power-off-multiple-sessions"
        )
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}