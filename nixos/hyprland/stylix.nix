{ pkgs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/d8/wallhaven-d83m63.jpg";
      #url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
      hash = "sha256-nT+ZptDmQPCE1r7j4mS3SmA4EU7qnAWhflK7sL7RmcY=";
    };

    #base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

    opacity.terminal = 0.97;

    # Options: "stretch", "fill", "fit", "center", "tile"
    imageScalingMode = "fill";

#    autoEnable = true;
    
    targets = {
      hyprland.enable = true;
      hyprland.hyprpaper.enable = false;
      hyprpanel.enable = true;
      hyprlock.enable = true;

      wofi.enable = true;
      wofi.colors.enable = true;

      kitty.enable = true;
    };
  };
}
