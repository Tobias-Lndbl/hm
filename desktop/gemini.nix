{ ... }:

{
  xdg.desktopEntries = {
    "gemini" = {
      name = "Google Gemini";
      exec = "firefox https://gemini.google.com --new-window";
      icon = "Gemini";
      comment = "open gemini in firefox";
      terminal = false;
      categories = [ "Education" ];
    };
  };
}

