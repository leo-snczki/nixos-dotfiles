{ self, inputs, config, pkgs, lib, ... }: # Ik some stuff isn’t being used, but I’m keeping it all for reference

{
  imports = [
    ./modules/home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "clotilde";
  home.homeDirectory = "/home/clotilde";
  home.pointerCursor.enable = true;
  home.file.".config/awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/awesome";

  home.stateVersion = "26.11";
  programs.home-manager.enable = true;

}
