{
  users.users = {
    rambo = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "NetworkManager" "wireshark" ];
    };
  };
}
