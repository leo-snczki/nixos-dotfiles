{ pkgs, ... }:

{
  home.packages = with pkgs; [
    desktop-file-utils
    discord
    fastfetch
    filezilla
    galculator
    lazygit
    libreoffice-qt
    pokeget-rs
    syncplay
    vlc
    xournalpp
    youtube-music
  ];
}
