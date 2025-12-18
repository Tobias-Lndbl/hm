{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user.name = "Tobias-Lndbl";
    settings.user.email = "phoenixt20000@gmail.com";
  };
}
