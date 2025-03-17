{ pkgs, config, ... }:

{
  xdg.desktopEntries.whatsapp = {
    name = "Whatsapp";
    genericName = "Messager App";
    exec = "xdg-open web.whatsapp.com/";
    terminal = false;
    categories = [ "Application" "Network" "Audio" "Video" "InstantMessaging" ];
    type = "Application";
    settings.StartupWMClass = "whatsapp";
  };
}
