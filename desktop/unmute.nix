{ ... }:

{
  xdg.desktopEntries = {
    "unmute" = {
      name = "Unmute";
      exec = "amixer -c 6 cset numid=28 on";
      icon = "none";
      comment = "unmute alsamixer PCM2 on amaterasu";
      terminal = false;
      categories = [ "Audio" ];
    };
  };
}

