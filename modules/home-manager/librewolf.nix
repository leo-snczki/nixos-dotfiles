{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;
    settings = {
      # Enable letterboxing
      "privacy.resistFingerprinting.letterboxing" = true;

      # WebGL
      "webgl.disabled" = true;

      "browser.preferences.defaultPerformanceSettings.enabled" = false;
      "layers.acceleration.disabled" = true;
      "network.trr.mode" = 3;
      "network.dns.disableIPv6" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.clearOnShutdown.history" = true;
      "privacy.clearOnShutdown.downloads" = true;
      "browser.sessionstore.resume_from_crash" = true;

      # See https://librewolf.net/docs/faq/#how-do-i-fully-prevent-autoplay for options
      "media.autoplay.blocking_policy" = 2;
      "media.peerconnection.enabled" = false;

      "privacy.resistFingerprinting" = true;
    };
    policies = {
      ExtensionSettings = {
        # istilldontcareaboutcookies
        "idcac-pub@guus.ninja" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          installation_mode = "force_installed";
        };
        # Darkreader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
