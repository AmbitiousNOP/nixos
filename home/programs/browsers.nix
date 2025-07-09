{pkgs, config, username, ...}:
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
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
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
	};
      };
      profiles.${username} = {};
    };
  };

}
