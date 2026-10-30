{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      font-awesome
      symbola
      material-icons
      fira-code
      fira-code-symbols
    ];
  };

  # The craft apps only look for fonts in /usr/share/fonts and ignore fontconfig.
  systemd.tmpfiles.rules = [
    "L+ /usr/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
  ];
}