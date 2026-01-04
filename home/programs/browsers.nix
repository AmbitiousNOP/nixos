{
  pkgs,
  config,
  ...
}:
let
  username = config.home.username;
in
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.librewolf;
      policies = {
        DisableTelemtry = true;
        DisableFirefoxStudies = true;
        Preferences = {
          "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
          "cookiebanners.service.mode" = 2; # Block cookie banners

          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.letterboxing" = true;

          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;

          "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          "privacy.resistFingerprinting.randomDataOnCanvasExtract" = true;

          "network.trr.mode" = 3;
          "network.trr.custom_uri" = "https://base.dns.mullvad.net/dns-query";
          "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";
          "network.http.referer.XOriginPolicy" = 2;

          "browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo Lite";
          "dom.security.https_only_mode_ever_enabled" = true;
          "security.tls.enable_0rtt_data" = false;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4524018/vimium_ff-2.3.xpi";
            installation_mode = "force_installed";
          };
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
            installation_mode = "force_installed";
          };
          "jid1-BoFifL9Vbdl2zQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4392113/decentraleyes-3.0.0.xpi";
            installation_mode = "force_installed";
          };
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4504218/privacy_badger17-2025.5.30.xpi";
            installation_mode = "force_installed";
          };
          "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4628164/noscript-13.5.xpi";
            installation_mode = "force_installed";
          };
          "CanvasBlocker@kkapsner.de" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4413485/canvasblocker-1.11.xpi";
            installation_mode = "force_installed";
          };
        };
      };
      profiles.${username} = { };
    };
  };

}
