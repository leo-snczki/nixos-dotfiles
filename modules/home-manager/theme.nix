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
}
