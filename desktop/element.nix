{ ... }:

{
  xdg.desktopEntries = {
    "element-desktop" = {
      name = "Element";
      exec = "element-desktop --profile tobiaslndbl";
      icon = "element";
      comment = "element desktop private profile";
      terminal = false;
      categories = [ "Network" "Chat" ];
      mimeType = [ "x-scheme-handler/element" ];
    };
  };
}
