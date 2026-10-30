{ inputs, lib, pkgs, ... }:

let
  craft = inputs.nix-craftapps.packages.${pkgs.stdenv.hostPlatform.system};
  names = builtins.attrNames (lib.importJSON "${inputs.nix-craftapps}/apps.json");

  # Run the GUI on the NVIDIA GPU (PRIME offload); <app>-cli, used by the MCP servers, stays untouched.
  onNvidia = name: pkgs.symlinkJoin {
    name = "${name}-nvidia";
    paths = [ craft.${name} ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm $out/bin/${name}
      makeWrapper ${craft.${name}}/bin/${name} $out/bin/${name} \
        --set __NV_PRIME_RENDER_OFFLOAD 1 \
        --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
        --set __GLX_VENDOR_LIBRARY_NAME nvidia \
        --set __VK_LAYER_NV_optimus NVIDIA_only
    '';
  };
in
{
  imports = [ inputs.nix-craftapps.homeManagerModules.default ];

  programs.craftapps = {
    enable = true;
    enableAll = true;
    skill.enable = true;
    mcp.enable = true;
    apps = lib.genAttrs names (name: { package = onNvidia name; });
  };
}
