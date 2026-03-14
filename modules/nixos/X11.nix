{ pkgs, ... }:

{
  services = {
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "none+awesome";
    xserver = {
      enable = true;
      wacom.enable = true;
      xkb = {
        variant = "abnt2"; #intl
        options = "lv3:ralt_switch,grp:win_space_toggle";
        layout = "br"; #us
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
