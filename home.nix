{ self, inputs, config, pkgs, lib, ... }: # Ik some stuff isn’t being used, but I’m keeping it all for reference

{
  imports = [
    ./modules/home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "rambo";
  home.homeDirectory = "/home/rambo";

  home.file.".config/awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/awesome";

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

}
