{ ... }:
{
  # Runs as a systemd user service tied to graphical-session.target (UWSM).
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
