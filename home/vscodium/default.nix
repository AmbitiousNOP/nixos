{pkgs, config, ...}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
	# dracula-theme.theme.dracula
	rust-lang.rust-analyzer
	arrterian.nix-env-selector
	teabyii.ayu
	#ginfuru.ginfuru-better-solarized-dark-theme
	oderwat.indent-rainbow
	vscodevim.vim
	ziglang.vscode-zig
      ];
      userSettings = {
	"nixEnvSelector.useFlakes" = true;
	"rust-analyzer.hover.documentation.enable" = false;
	"workbench.colorTheme" = "Ayu Dark Bordered";
	"nixEnvSelector.packages" = [];
	"editor.fontSize" = 18;
	"zig.formattingProvider" = "off";
	"zig.zls.enabled" = "off";
	#"indentRainbow.indicatorStyle" = "light";
      };
	enableUpdateCheck = false;
	enableExtensionUpdateCheck = false;
    };
  };
}
