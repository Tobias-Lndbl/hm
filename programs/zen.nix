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
{
  inputs,
  pkgs,
  ...
}:
let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in
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

      # Add-ons come from rycee's packaged set (see the firefox-addons flake
      # input). `settings` below already places both browser-action buttons in
      # the toolbar, so they land where they did on inari.
      #
      # To add one: look it up with
      #   nix search gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons <name>
      extensions.packages = with addons; [
        ublock-origin
        bitwarden
      ];

      # WARNING: leave this false until every space below is declared.
      # When true, any space that is NOT listed here gets deleted on switch --
      # flipping it on with an incomplete list wipes the spaces on amaterasu.
      spacesForce = true;

      # Containers are referenced by numeric id from `spaces.*.container` and
      # from each pin. The ids are per-profile and are NOT recreated on a fresh
      # device, so they have to be declared alongside the spaces or the
      # bindings dangle (which is what remapped "cloud" to 1 on izanagi).
      #
      # 1-4 are Zen's built-ins, redeclared here because containersForce
      # rewrites containers.json wholesale and would otherwise drop them.
      containersForce = true;
      containers = {
        "Personal" = { id = 1; icon = "fingerprint"; color = "blue"; };
        "Work" = { id = 2; icon = "briefcase"; color = "orange"; };
        "Banking" = { id = 3; icon = "dollar"; color = "green"; };
        "Shopping" = { id = 4; icon = "cart"; color = "pink"; };

        # One per space, ids matching what the spaces/pins already reference.
        "home" = { id = 6; icon = "tree"; color = "pink"; };
        "uni" = { id = 7; icon = "briefcase"; color = "green"; };
        "cloud" = { id = 8; icon = "circle"; color = "purple"; };
      };

      spaces = {
        "cloud" = {
          id = "8f24ebd1-2391-4084-9dd1-7e323a0b6f13";
          position = 1000;
          icon = "chrome://browser/skin/zen-icons/selectable/cloud.svg";
          container = 8;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 238;
                green = 119;
                blue = 154;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 221;
                position.y = 167;
                custom = false;
                primary = true;
              }
              {
                red = 238;
                green = 186;
                blue = 119;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 215;
                position.y = 203;
                custom = false;
                primary = true;
              }
              {
                red = 223;
                green = 119;
                blue = 238;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 197;
                position.y = 139;
                custom = false;
                primary = true;
              }
            ];
            opacity = 0.581;
            texture = 0.5;
          };
          pins = {
            "Sign in - Claude" = {
              id = "bbc62752-c9cf-5e4a-8f08-c19e9a6dd419";
              url = "https://claude.ai/login?from=logout&reauth=1&returnTo=%2Fchat%2F89a3aefc-7067-40d4-921b-3d307b432199%3F";
              position = 100;
              isEssential = true;
              container = 8;
            };
            "Google Gemini" = {
              id = "b88400b1-4751-58a9-a07c-992bfbd2312d";
              url = "https://gemini.google.com/app";
              position = 200;
              isEssential = true;
              container = 8;
            };
            "Gmail" = {
              id = "a6f56980-d81a-5a74-8bcc-6ab22cd39935";
              url = "https://accounts.google.com/v3/signin/identifier?continue=https://mail.google.com/mail/u/0/&emr=1&followup=https://mail.google.com/mail/u/0/&osid=1&passive=1209600&service=mail&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S-198808794:1790001259347406#inbox";
              position = 300;
              isEssential = true;
              container = 8;
            };
            "Netflix Germany - Watch TV Shows Online, Watch Movies Online" = {
              id = "37d1cbe8-28b0-5fe3-8f9a-12038f37fee3";
              url = "https://www.netflix.com/de-en/";
              position = 400;
              isEssential = true;
              container = 8;
            };
            "Sumo Ring (Eiche/Damast) | Holzkern" = {
              id = "2f72e8e5-1efb-53e6-ad0a-e8a5737eb75a";
              url = "https://holzkern.com/products/sumoring-eiche-damast?variant=54207995609427";
              position = 500;
              container = 8;
            };
          };
        };
        "home" = {
          id = "91a1461f-3d5c-45d0-b541-95a7e3aa0a33";
          position = 2000;
          icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
          container = 6;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 233;
                green = 124;
                blue = 212;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 217;
                position.y = 138;
                custom = false;
                primary = true;
              }
              {
                red = 233;
                green = 127;
                blue = 124;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 235;
                position.y = 182;
                custom = false;
                primary = true;
              }
              {
                red = 164;
                green = 124;
                blue = 233;
                lightness = 70;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 172;
                position.y = 124;
                custom = false;
                primary = true;
              }
            ];
            opacity = 0.5;
            texture = 0.5;
          };
          pins = {
            "authentik" = {
              id = "780447cf-d5c0-5424-ac5f-2aec27d5ba44";
              url = "https://authentik.lndbl.de/if/user/#/library";
              position = 100;
              isEssential = true;
              container = 6;
            };
            "Mail - Nextcloud" = {
              id = "97b927f9-ddcd-51ce-abc0-46f33bf61b55";
              url = "https://nextcloud.lndbl.de/apps/mail/box/20#";
              position = 200;
              container = 6;
            };
            "Week 39 of 2026 - Calendar - Nextcloud" = {
              id = "fcc4fda8-20fa-51e5-86e1-e5fc0fff3a0d";
              url = "https://nextcloud.lndbl.de/apps/calendar/timeGridWeek/now";
              position = 300;
              container = 6;
            };
          };
        };
        "uni" = {
          id = "591c5411-c7b3-4ff6-9c17-d94e86c5e4ef";
          position = 3000;
          icon = "chrome://browser/skin/zen-icons/selectable/school.svg";
          container = 7;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 70;
                green = 236;
                blue = 168;
                lightness = 60;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 147;
                position.y = 195;
                custom = false;
                primary = true;
              }
              {
                red = 70;
                green = 169;
                blue = 236;
                lightness = 60;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 146;
                position.y = 165;
                custom = false;
                primary = true;
              }
              {
                red = 110;
                green = 237;
                blue = 69;
                lightness = 60;
                algorithm = "analogous";
                type = "explicit-lightness";
                position.x = 171;
                position.y = 214;
                custom = false;
                primary = true;
              }
            ];
            opacity = 0.404;
            texture = 0.5;
          };
          pins = {
            "Log in | Zulip" = {
              id = "1504977c-31e2-5652-bf3d-9e9e8592c51e";
              url = "https://zulip.in.tum.de/login/";
              position = 100;
              isEssential = true;
              container = 7;
            };
            "Anmeldeseite | TUM" = {
              id = "2b08df23-9ba3-5608-858f-f269ee223776";
              url = "https://www.moodle.tum.de/login/index.php";
              position = 200;
              isEssential = true;
              container = 7;
            };
            "Artemis Maintenance" = {
              id = "2098ec4c-9744-5bac-bfc3-e05ebbdd0d6c";
              url = "https://artemis.tum.de/courses/531/exercises/19152";
              position = 300;
              isEssential = true;
              container = 7;
            };
            "Home - TUMonline - Technische Universität München" = {
              id = "851770b2-b8e6-5427-ac49-c013fa3257e4";
              url = "https://campus.tum.de/tumonline/ee/ui/ca2/app/desktop/#/home?\$ctx=lang=EN";
              position = 400;
              isEssential = true;
              container = 7;
            };
          };
        };
      };
      settings = {
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "standard";
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.download.lastDir" = "/home/tbsl/Downloads";
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.engagement.ctrlTab.has-used" = true;
        "browser.engagement.downloads-button.has-used" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled.migrated" = true;
        "browser.newtabpage.activity-stream.system.showWeatherOptIn" = false;
        "browser.open.lastDir" = "/home/tbsl/Nextcloud/uni/s26/linalg/material";
        "browser.pageActions.persistedActions" =
          "{\"ids\":[\"bookmark\"],\"idsInUrlbar\":[\"bookmark\"],\"idsInUrlbarPreProton\":[],\"version\":1}";
        "browser.preferences.experimental.hidden" = true;
        "browser.rights.3.shown" = true;
        "browser.search.totalSearches" = 73;
        "browser.settings-redesign.promo.dismissed" = true;
        "browser.shell.mostRecentDateSetAsDefault" = "1789982489";
        "browser.theme.toolbar-theme" = 0;
        "browser.uiCustomization.state" =
          "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"unified-extensions-button\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"ublock0_raymondhill_net-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"],\"zen-sidebar-top-buttons\":[\"zen-toggle-compact-mode\"],\"zen-sidebar-foot-buttons\":[\"downloads-button\",\"zen-workspaces-button\",\"zen-create-new-button\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"zen-sidebar-foot-buttons\",\"PersonalToolbar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\",\"zen-sidebar-top-buttons\"],\"currentVersion\":24,\"newElementCount\":3}";
        "browser.urlbar.lastUrlbarSearchSeconds" = 1789993752;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "devtools.everOpened" = true;
        "devtools.toolbox.selectedTool" = "webconsole";
        "dom.forms.autocomplete.formautofill" = true;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
        "extensions.ui.dictionary.hidden" = false;
        "extensions.ui.extension.hidden" = false;
        "extensions.ui.lastCategory" = "addons://list/locale";
        "extensions.ui.locale.hidden" = false;
        "extensions.ui.mlmodel.hidden" = true;
        "extensions.ui.sitepermission.hidden" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.uBlock0@raymondhill.net" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.{446900e4-71c2-419f-a6a7-df9c091e268b}" =
          true;
        "identity.fxaccounts.account.device.name" = "tbsl’s Zen on inari";
        "intl.accept_languages" = "en-us,de,en";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "media.videocontrols.picture-in-picture.video-toggle.first-seen-secs" = 1785869705;
        "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;
        "mod.remove-tab-x.scope" = "all";
        "mod.tidypopup.hovercolor" = "rgba(80, 80, 250, 1)";
        "mod.tidypopup.usecustomhovercolor" = false;
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
        "psu.better_ctrltab.background" = "light-dark(rgba(144, 144, 144, 0.94), rgba(22, 22, 22, 0.92))";
        "psu.better_ctrltab.padding" = "16px";
        "psu.better_ctrltab.preview_border_color" =
          "light-dark(rgba(255, 255, 255, 0.1), rgba(1, 1, 1, 0.1))";
        "psu.better_ctrltab.preview_border_width" = "1px";
        "psu.better_ctrltab.preview_favicon_outdent" = "12px";
        "psu.better_ctrltab.preview_favicon_size" = "36px";
        "psu.better_ctrltab.preview_focus_background" =
          "light-dark(rgba(77, 77, 77, 0.8), rgba(204, 204, 204, 0.33))";
        "psu.better_ctrltab.preview_font_size" = "13px";
        "psu.better_ctrltab.preview_letter_spacing" = "0px";
        "psu.better_ctrltab.roundness" = "28px";
        "psu.better_ctrltab.shadow_size" = "18px";
        "psu.better_ctrltab.zoom" = "0.8";
        "services.sync.clients.lastSync" = "0";
        "services.sync.declinedEngines" = "";
        "services.sync.globalScore" = 0;
        "services.sync.nextSync" = 0;
        "sidebar.installed.extensions" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        "sidebar.main.tools" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        "sidebar.visibility" = "hide-sidebar";
        "signon.firefoxRelay.feature" = "disabled";
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "theme-better_find_bar-enable_custom_background" = true;
        "theme.better_find_bar.custom_background" = "#112233";
        "theme.better_find_bar.hide_find_status" = false;
        "theme.better_find_bar.hide_found_matches" = false;
        "theme.better_find_bar.hide_highlight" = "not_hide";
        "theme.better_find_bar.hide_match_case" = "not_hide";
        "theme.better_find_bar.hide_match_diacritics" = "not_hide";
        "theme.better_find_bar.hide_whole_words" = "not_hide";
        "theme.better_find_bar.horizontal_position" = "default";
        "theme.better_find_bar.instant_animations" = false;
        "theme.better_find_bar.textbox_width" = "800";
        "theme.better_find_bar.transparent_background" = true;
        "theme.better_find_bar.vertical_position" = "default";
        "theme.nosidebarscrollbar.before125b" = false;
        "theme.smaller_compact_mode.sidebar_height" = "70";
        "uc.theme.tab_indicator.color" = "var(--tab-indicator-color)";
        "uc.theme.tab_indicator.width" = "4px";
        "zen.tabs.ctrl-tab.ignore-essential-tabs" = true;
        "zen.tabs.select-recently-used-on-close" = false;
        "zen.tabs.show-newtab-vertical" = false;
        "zen.tabs.vertical.right-side" = true;
        "zen.urlbar.suggestions-learner" =
          "{\"Browser:ReloadSkipCache\":-5,\"cmd_zenWorkspaceForward\":-5,\"Browser:NextTab\":-5,\"zen:global-action-settings\":-2,\"cmd_zenNewEmptySplit\":-2,\"zen:global-action-new-boost\":-2,\"zen:extension-{446900e4-71c2-419f-a6a7-df9c091e268b}\":-1,\"cmd_zenOpenSpaceRoutingSettings\":-1,\"cmd_zenToggleTabsOnRight\":-5,\"cmd_find\":-1}";
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.view.sidebar-expanded" = false;
        "zen.view.use-single-toolbar" = false;
      };

      mods = [
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "5941aefd-67b0-453d-9b62-9071a31cbb0d" # Smaller Compact Mode
        "c5f7fb68-cc75-4df0-8b02-dc9ee13aa773" # Audio TabIcon Plus
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
      ];

      # Same idea as spacesForce, for pinned/essential tabs. Turn on once the
      # pins above are complete; "remove" deletes undeclared pins, "demote"
      # just unpins them.
      pinsForce = true;
      pinsForceAction = "demote";

      # Mod UUIDs from the Zen mod store (zen-themes.json on a configured box).
      # userChrome = '''';
    };
  };
}
