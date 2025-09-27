{ config, pkgs, vars, ... }:
let
  socket = config.services.phpfpm.pools.${vars.app}.socket;
in
{
  systemd.services.nginx.serviceConfig.ProtectHome = false;

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      root = vars.dataDir;
      locations."~ \\.php$".extraConfig = ''
        fastcgi_pass  unix:${socket};
        fastcgi_index index.php;
      '';
    };
  };

  # I am using docker-compose so I dont need mysql installed
  # mysql was keeping the port so I disabled it to let my docker compose use
  # I could change the port of my docker compose but I dont want to deal with possible errors

  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  # };

  services.phpfpm.phpOptions = ''
  display_errors = on;
'';

  services.phpfpm.pools.${vars.app} = {
    user = vars.app;
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };

  users.users.${vars.app} = {
    isSystemUser = true;
    home = vars.dataDir;
    group = vars.app;
  };

  users.groups.${vars.app} = { };

system.activationScripts.sitePermissions = {
  text = ''
    chown -R ${vars.app}:${vars.app} ${vars.dataDir}
    chmod -R 755 ${vars.dataDir}  
  '';
};
}
