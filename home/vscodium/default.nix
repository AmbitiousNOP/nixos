{pkgs, config, ...}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # dracula-theme.theme.dracula
      rust-lang.rust-analyzer
      arrterian.nix-env-selector
      teabyii.ayu
    ];
    userSettings = {
      "nixEnvSelector.useFlakes" = true;
      "rust-analyzer.hover.documentation.enable" = false;
      "workbench.colorTheme" = "Ayu Dark Bordered";
      "nixEnvSelector.packages" = [];
    };
  };
}
