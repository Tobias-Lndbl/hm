# Declarative Zen Browser configuration.
#
# Goal: a fresh device needs only `home-manager switch` to end up with the same
# spaces, pinned tabs, mods, shortcuts and prefs as every other machine.
# Nothing leaves this repo -- no Mozilla account, no sync server, no cloud.
#
# Where Zen actually keeps this state (useful when debugging):
#   spaces + pins  ->  <profile>/zen-sessions.jsonlz4   (NOT places.sqlite)
#   space routing  ->  <profile>/zen-space-routing.jsonlz4
#   shortcuts      ->  <profile>/zen-keyboard-shortcuts.json
#   mods           ->  <profile>/zen-themes.json + chrome/zen-themes.css
#   prefs          ->  <profile>/prefs.js
#
# The module writes those same files, so Zen MUST be closed when switching,
# otherwise Zen overwrites them again on exit.
#
# To lift the spaces/prefs you already built on another device into this file:
#   python3 ~/.config/hm/scripts/zen-export-spaces.py --spaces
#   python3 ~/.config/hm/scripts/zen-export-spaces.py --prefs
{ ... }:
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # Enforced, not overridable from the UI -- so they can't drift per device.
    policies = {
      AppAutoUpdate = false; # nix owns the version, not the updater
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      # Uncomment to hard-disable Mozilla account sign-in entirely. Left on so
      # you can still opt into Zen's native Spaces sync later if you want it.
      # DisableFirefoxAccounts = true;
    };

    profiles.default = {
      id = 0;
      isDefault = true;

      # Directory name under ~/.config/zen.
      #
      # ONE-TIME MIGRATION, per device: Zen's own profile dir is named
      # "<random>.Default Profile". Adopt it instead of letting home-manager
      # create an empty one next to it (which would look like losing all
      # history, cookies and logins):
      #
      #   pkill -f zen; sleep 2
      #   cd ~/.config/zen
      #   cp -a profiles.ini profiles.ini.bak
      #   mv *.Default\ Profile default
      #   cd ~ && home-manager switch --flake ~/.config/hm#tbsl@$(hostname)
      #
      # Devices already migrated: (none yet -- tick off as you go)
      path = "default";

      # Prefs that otherwise have to be re-clicked on every new device.
      # Add your own here -- `--prefs` mode of the export script lists the ones
      # you changed by hand on an already-configured machine.
      settings = {
        "app.update.auto" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
      };

      # WARNING: leave this false until every space below is declared.
      # When true, any space that is NOT listed here gets deleted on switch --
      # flipping it on with an incomplete list wipes the spaces on amaterasu.
      spacesForce = false;

      spaces = {
        # Placeholder matching the single space this profile currently has.
        # Replace this whole block with the output of
        #   python3 ~/.config/hm/scripts/zen-export-spaces.py --spaces
        # run on the device whose Zen is already set up the way you want.
        "Space" = {
          id = "207b1cf5-e3ed-4a20-9078-9e4dff08f6f1";
          position = 1000;

          # pins."Mail" = {
          #   id = "5e8db6a4-92c7-4f31-8a60-1b9f3ce47d28"; # any unique v4 UUID
          #   url = "https://mail.example.com";
          #   position = 100;
          #   isEssential = true;
          # };
        };
      };

      # Same idea as spacesForce, for pinned/essential tabs. Turn on once the
      # pins above are complete; "remove" deletes undeclared pins, "demote"
      # just unpins them.
      pinsForce = false;
      pinsForceAction = "demote";

      # Mod UUIDs from the Zen mod store (zen-themes.json on a configured box).
      mods = [ ];

      # userChrome = '''';
    };
  };
}
