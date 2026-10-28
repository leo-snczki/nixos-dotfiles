{ inputs, pkgs, ... }:

{
  programs.dconf.enable = true;
  services.picom.enable = true;

  environment.systemPackages =
    with pkgs; [

      alsa-utils
      arandr
      asar
      btop
      cava
      cavasik
      docker-buildx
      docker-compose
      easyeffects
      evtest
      exfat
      exfatprogs
      file-roller
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
      playerctl
      polkit_gnome
      polkit
      p7zip
      scrcpy
      sxiv
      thunar-archive-plugin
      thunar-volman
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
