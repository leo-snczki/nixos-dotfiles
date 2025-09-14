{ config, ... }:

{
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/share";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "draw.desktop";
        "text/plain" = "codium.desktop";
        "text/markdown" = "codium.desktop";
        "text/x-c" = "codium.desktop";
        "text/x-c++src" = "codium.desktop";
        "application/json" = "codium.desktop";
        "application/javascript" = "codium.desktop";
        "text/html" = "codium.desktop";
        "application/xml" = "codium.desktop";
        "text/css" = "codium.desktop";
        "application/x-shellscript" = "codium.desktop";
        "inode/directory" = "thunar.desktop";
        "image/*" = "sxiv.desktop";
        "video/*" = "vlc.desktop";
        "audio/*" = "vlc.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/rar" = "org.gnome.FileRoller.desktop";
      };
    };
  };
}
