{ self, inputs, system, config, lib, pkgs, ... }: #ik it is not being used, but I want to keep it for reference.

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/nixos
    ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    #  	package = pkgs.nixFlakes;
    settings = {
      download-buffer-size = 524288000;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  time.timeZone = "Europe/London";

  system.stateVersion = "25.11";
}

