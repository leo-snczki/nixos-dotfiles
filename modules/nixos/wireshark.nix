{pkgs, ...}:
{
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark-qt;
  programs.wireshark.dumpcap.enable = true;
  programs.wireshark.usbmon.enable = true; # to get info from usb network card
}