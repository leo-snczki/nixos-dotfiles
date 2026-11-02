{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    arduino-ide
    python312
    desktop-file-utils
    discord
    esptool
    fastfetch
    filezilla
    fritzing
    fzf
    galculator
    inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.viu.packages.${pkgs.stdenv.hostPlatform.system}.default
    lazygit
    pokeget-rs
    rofimoji
    rofi-screenshot
    syncplay
    torrserver
    vlc
    xournalpp
  ];
}
