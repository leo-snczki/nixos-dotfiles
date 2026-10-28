{
  users.users = {
    clotilde = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "NetworkManager" "wireshark" "dialout"];
    };
  };
}
