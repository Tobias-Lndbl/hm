{ lib, ... }:
{
  xdg.configFile."caelestia/shell.json".force = true;
  xdg.configFile."caelestia/cli.json".force = true;

  home.activation.caelestiaMutableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for f in "$HOME/.config/caelestia/shell.json"; do
      if [ -L "$f" ]; then
        target=$(readlink -f "$f")
        rm "$f"
        cp "$target" "$f"
        chmod u+w "$f"
      fi
    done
  '';

  xdg.configFile."caelestia/templates/kitty.conf".text = ''
    foreground #{{ onSurface.hex }}
    background #{{ surface.hex }}
    cursor #{{ secondary.hex }}
    selection_background #{{ secondary.hex }}
    color0 #{{ term0.hex }}
    color1 #{{ term1.hex }}
    color2 #{{ term2.hex }}
    color3 #{{ term3.hex }}
    color4 #{{ term4.hex }}
    color5 #{{ term5.hex }}
    color6 #{{ term6.hex }}
    color7 #{{ term7.hex }}
  '';

  programs.caelestia = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./caelestia_settings.json);
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [ ];
    };

    cli = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./caelestia_cli.json);
    };
  };
}
