{ self, pkgs, lib, ... }:

# https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix

let
  inherit (lib) mkForce;
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.default = {
      settings = {
        "zoom.minPercent" = 133;
        "zoom.defaultPercent" = 150;
        "webgl.disabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.engines" = false;
      };
    };

    # Refer to https://mozilla.github.io/policy-templates or `about:policies#documentation` in firefox
    policies = {
      AppAutoUpdate = false; # Disable automatic application update
      BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running
      DisableBuiltinPDFViewer = true; # Considered a security liability
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true; # Disable Firefox Sync
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true; # Thing that can wipe history for X time, handled differently
      DisableMasterPasswordCreation = true; # To be determined how to handle master password
      DisableProfileImport = true; # Purity enforcement: Only allow nix-defined profiles
      DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
      DisableSetDesktopBackground = true; # Remove the “Set As Desktop Background…” menuitem when right clicking on an image, because Nix is the only thing that can manage the backgroud
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "default-off";
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = false; # Disabled as it's exposes points for fingerprinting
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };
      ExtensionUpdate = false;
      # FIXME(Krey): Review `~/.mozilla/firefox/Default/extensions.json` and uninstall all unwanted
      # NOTE(Krey): Check if the addon is packaged on https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
      ExtensionSettings = {
        "*" = {
          installation_mode = "blocked";
          blocked_install_message = "FUCKING FORGET IT!";
        };
        "addon@darkreader.org" = {
          # 	# Dark Reader
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.darkreader}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon@darkreader.org.xpi";
          installation_mode = "force_installed";
        };
        # "7esoorv3@alefvanoon.anonaddy.me" = {
        #   # LibRedirect
        #   install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.libredirect}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/7esoorv3@alefvanoon.anonaddy.me.xpi";
        #   installation_mode = "force_installed";
        # };
        "dont-track-me-google@robwu.nl" = {
          # Don't Track Me Google
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dont-track-me-google1/latest.xpi";
          installation_mode = "force_installed";
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          # ClearURLs
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.clearurls}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{74145f27-f039-47ce-a470-a662b129930a}.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          # Sponsor Block
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/sponsorBlocker@ajay.app.xpi";
          installation_mode = "force_installed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          # Privacy Badger
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.privacy-badger}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid1-MnnxcxisBPnSXQ@jetpack.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          # uBlock Origin
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/uBlock0@raymondhill.net.xpi";
          installation_mode = "force_installed";
        };
        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.tridactyl}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/tridactyl.vim@cmcaine.co.uk.xpi";
          installation_mode = "force_installed";
        };
        "idcac-pub@guus.ninja" = {
          # I Still Don't Care About Cookies
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.istilldontcareaboutcookies}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/idcac-pub@guus.ninja.xpi";
          installation_mode = "force_installed";
        };
        "CanvasBlocker@kkapsner.de" = {
          # Canvas Blocker
          install_url = "file:///${self.inputs.firefox-addons.packages.x86_64-linux.canvasblocker}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/CanvasBlocker@kkapsner.de.xpi";
          installation_mode = "force_installed";
        };
      };

      "3rdparty".Extensions = {
        # https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = rec {
            uiTheme = "dark";
            uiAccentCustom = true;
            uiAccentCustom0 = "#8300ff";
            cloudStorageEnabled = mkForce false; # Security liability?
            importedLists = [
              "https://filters.adtidy.org/extension/ublock/filters/3.txt"
              "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            ];
            externalLists = lib.concatStringsSep "\n" importedLists;
          };
          selectedFilterLists = [

            "adguard-generic"
            "adguard-annoyance"
            "adguard-social"
            "adguard-spyware-url"
            "easylist"
            "easyprivacy"
            "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            "plowe-0"
            "ublock-abuse"
            "ublock-badware"
            "ublock-filters"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "urlhaus-1"
          ];
        };
      };

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      NoDefaultBookmarks = true;
      PDFjs = {
        Enabled = false;
        EnablePermissions = false;
      };
      Permissions = {
        Camera = {
          # 		Allow = [https =//example.org,https =//example.org =1234];
          # 		Block = [https =//example.edu];
          BlockNewRequests = true;
          Locked = true;
        };
        Microphone = {
          Allow = [
            "https://teams.microsoft.com"
            "https://*.teams.microsoft.com"
          ];
          # 		Block = [https =//example.edu];
          BlockNewRequests = true;
          Locked = true;
        };
        Location = {
          # 		Allow = [https =//example.org];
          # 		Block = [https =//example.edu];
          BlockNewRequests = true;
          Locked = true;
        };
        # 	Notifications = {
        # 		Allow = [https =//example.org];
        # 		Block = [https =//example.edu];
        # 		BlockNewRequests = true;
        # 		Locked = true;
        # 	};
        # 	Autoplay = {
        # 		Allow = [https =//example.org];
        # 		Block = [https =//example.edu];
        # 		Default = allow-audio-video | block-audio | block-audio-video;
        # 		Locked = true;
        # 	};
      };
      PictureInPicture = {
        Enabled = true;
        Locked = true;
      };
      PromptForDownloadLocation = true;

      SanitizeOnShutdown = {
        Cache = true;
        Cookies = false;
        Downloads = true;
        FormData = true;
        History = false;
        Sessions = false;
        SiteSettings = false;
        OfflineApps = true;
        Locked = true;
      };
      SearchEngines = {
        PreventInstalls = true;
        Remove = [
          "Amazon.com"
          "Bing"
        ];
        Default = "Google";
      };
      SearchSuggestEnabled = false;
      ShowHomeButton = true;
      StartDownloadsInTempDirectory = true;
      UserMessaging = {
        ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
        FeatureRecommendations = false; # Don’t recommend browser features
        Locked = true; # Prevent the user from changing user messaging preferences
        MoreFromMozilla = false; # Don’t show the “More from Mozilla” section in Preferences
        SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
        UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
        WhatsNew = false; # Remove the “What’s New” icon and menuitem
      };



      #UseSystemPrintDialog = true;
      # WebsiteFilter = {
      # 	Block = [<all_urls>];
      # 	Exceptions = [http =//example.org/*]
      # };
    };
  };
}
