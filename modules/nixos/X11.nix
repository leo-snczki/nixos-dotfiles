{ pkgs, ... }:

{
  services = {
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "none+awesome";
    xserver = {
      enable = true;
      wacom.enable = true;   
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
