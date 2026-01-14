{
  virtualisation.docker = {
    enable = false;
    autoPrune.enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
