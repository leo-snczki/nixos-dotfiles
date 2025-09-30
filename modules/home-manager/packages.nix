{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    desktop-file-utils
    discord
    fastfetch
    filezilla
    galculator
    inputs.yt-x.packages."${system}".default
    lazygit
    libreoffice-qt
    pokeget-rs
    rofi-screenshot
    syncplay
    vlc
    xournalpp
    youtube-music
  ];
}
