{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions;
      [
        dracula-theme.theme-dracula
        bmewburn.vscode-intelephense-client
        jnoortheen.nix-ide
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime
        ms-dotnettools.vscodeintellicode-csharp
        ms-python.python
        ms-vscode.live-server
        ms-vsliveshare.vsliveshare
        ritwickdey.liveserver
        sumneko.lua
        yzhang.markdown-all-in-one
        xdebug.php-debug
      ];
  };
}
