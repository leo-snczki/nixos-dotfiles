{ inputs, pkgs, ... }:

{
  programs.file-roller.enable = true;
  programs.dconf.enable = true;
  services.picom.enable = true;

  environment.systemPackages =
    let
      php = pkgs.php.buildEnv { extraConfig = "memory_limit = 2G"; };
    in
    with pkgs; [

      alsa-utils
      arandr
      asar
      btop
      docker-buildx
      easyeffects
      evtest
      deluge-gtk
      git
      gparted
      # kdePackages.kwallet
      # kdePackages.kwalletmanager
      # kdePackages.kwallet-pam
      inputs.compose2nix.packages.x86_64-linux.default
      iw
      jq
      love
      lshw
      luajitPackages.luarocks
      mc
      net-tools
      nixd
      nixpkgs-fmt
      nix-search-cli
      pavucontrol
      php
      playerctl
      polkit_gnome
      polkit
      p7zip
      scrcpy
      sxiv
      unzip
      usbutils
      veracrypt
      vim
      v4l-utils # Used For Things Like OBS Virtual Camera
      wget
      xclip
      zenith-nvidia
    ];
}
