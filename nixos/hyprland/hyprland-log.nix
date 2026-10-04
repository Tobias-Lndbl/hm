{ pkgs, ... }:

# Persist Hyprland's log across reboots.
#
# Hyprland logs to $XDG_RUNTIME_DIR/hypr/<signature>/hyprland.log, which lives
# on tmpfs and is destroyed on reboot. That cost us the only useful evidence
# for the 2026-10-04 black screen: hibernation resumed fine after 20h35m and
# the session stayed alive (the lock screen authenticated blind typing), but
# nothing came out of the RTX 4070 -- and the NVIDIA driver logged nothing at
# all across the whole cycle, so the compositor's own log was the only place
# that could have said whether the outputs came back without modes. It was
# gone by the time anyone looked.
#
# Tailing rather than relocating the log dir on purpose: $XDG_RUNTIME_DIR/hypr
# also holds the IPC sockets, and putting those on disk means stale instance
# dirs pile up with nothing to clean them. If this service dies, Hyprland does
# not care.
#
# Output is line-buffered so a crash loses at most the current line from the
# page cache. ~23 MB/day at observed verbosity, pruned after 14 days. This is
# deliberately a file rather than the journal -- that volume of compositor
# chatter would drown everything else in journalctl.

let
  persistLog = pkgs.writeShellApplication {
    name = "hyprland-log-persist";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
    ];
    text = ''
      dest="$HOME/.local/state/hyprland-logs"
      mkdir -p "$dest"
      find "$dest" -name 'hyprland-*.log' -mtime +14 -delete || true

      # The compositor creates its log a moment after the unit starts.
      log=""
      for _ in $(seq 1 120); do
        log=$(find "$XDG_RUNTIME_DIR/hypr" -maxdepth 2 -name hyprland.log \
                -printf '%T@ %p\n' 2>/dev/null \
              | sort -rn | head -1 | cut -d' ' -f2-)
        [ -n "$log" ] && break
        sleep 0.5
      done

      if [ -z "$log" ]; then
        echo "no hyprland.log under $XDG_RUNTIME_DIR/hypr after 60s" >&2
        exit 1
      fi

      out="$dest/hyprland-$(date +%Y%m%d-%H%M%S).log"
      echo "persisting $log -> $out"
      exec stdbuf -oL tail -n +1 -F "$log" >>"$out"
    '';
  };
in
{
  systemd.user.services.hyprland-log-persist = {
    Unit = {
      Description = "Persist Hyprland's log to ~/.local/state/hyprland-logs";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${persistLog}/bin/hyprland-log-persist";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
