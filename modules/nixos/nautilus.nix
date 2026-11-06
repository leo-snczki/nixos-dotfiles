{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  # "Open in Terminal" entry in the right-click menu
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # Search inside Nautilus
  services.gnome.localsearch.enable = true;
  services.gnome.tinysparql.enable = true;
}
