{ pkgs, ... }:

{
  services = {
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "none+awesome";
    xserver = {
      enable = true;
      xkb = {
        variant = "intl";
        options = "lv3:ralt_switch,grp:win_space_toggle";
        layout = "us";
      };      
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
          luadbi-mysql
        ];
      };
    };
  };
}
