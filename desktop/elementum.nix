{ ... }:

{
  xdg.desktopEntries = {
    "elementum" = {
      name = "tum element";
      exec = "element-desktop --profile tum";
      icon = "element";
      comment = "element desktop university profile";
      terminal = false;
      categories = [ "Network" "Chat" ];
      mimeType = [ "x-scheme-handler/element" ];
    };
  };
}
