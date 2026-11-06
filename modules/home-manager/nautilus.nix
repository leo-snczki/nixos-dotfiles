{ config, ... }:

{
  # Nautilus only shows bookmarks in its sidebar; GNOME seeds them with
  # xdg-user-dirs-gtk on login, which never runs under awesome.
  gtk.gtk3.bookmarks = with config.xdg.userDirs; map (dir: "file://${dir}") [
    desktop
    documents
    download
    music
    pictures
    videos
  ];
}
