{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    desktop-file-utils
    discord
    fastfetch
    filezilla
    fzf
    galculator
    inputs.yt-x.packages."${system}".default
    inputs.affinity-nix.packages."${system}".default
    inputs.viu.packages."${system}".default
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
