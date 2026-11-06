{ pkgs, ... }:

{
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-black";
    };
  };

  # GTK4/libadwaita apps (Nautilus and other GNOME apps) ignore the GTK theme
  # and follow this setting instead.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
