{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    package = pkgs.picom;

    backend = "glx";
    vSync = true;

    fade = true;
    fadeDelta = 10;
    fadeSteps = [ 0.05 0.05 ];
    fadeExclude = [ "window_type *= 'menu'" ];

    activeOpacity = 1;
    inactiveOpacity = 1;
    opacityRules = [
      "90:class_g = 'rofi'"
      "90:class_g = 'thunar'"
      "90:class_g = 'codium'"
    ];

    settings = {
      glx-copy-from-font = false;
      use-damage = true;
      frame-opacity = 1;
      blur-background = true;
      blur-method = "dual_kawase";
      blur-strength = 6;
      corner-radius = 12;
      rounded-corners-exclude = [ "window_type = 'dock'" ];
    };

    # picom >= 12 animation scripts. A list of groups needs libconfig's ( ... ),
    # which `settings` can't produce (it renders lists as [ ... ]).
    extraConfig = ''
      animations = (
        { triggers = [ "open", "show" ]; preset = "slide-in"; direction = "up"; duration = 0.2; },
        { triggers = [ "close", "hide" ]; preset = "slide-out"; direction = "down"; duration = 0.15; }
      );
    '';
  };
}