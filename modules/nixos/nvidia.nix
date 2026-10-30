{ config, pkgs, ... }:

{
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # VA-API driver (iHD) for the Intel iGPU, so browsers can decode video in hardware.
    extraPackages = [ pkgs.intel-media-driver ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
    modesetting.enable = true;

    # Save/restore VRAM across suspend (nvidia-suspend/resume services).
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}