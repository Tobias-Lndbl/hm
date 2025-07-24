{pkgs, inputs, ...}:

{
   nixpkgs.overlays = [
    (_: _: { waybar_git = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar; })
   ]; 
}
