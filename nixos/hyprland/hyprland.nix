{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # With configType = "lua" the settings-attrset backend is unreliable for
    # $variables and dispatcher strings (nix-community/home-manager#9468), so
    # we write the actual hyprland.lua by hand here instead.
    settings = { };

    extraConfig = ''
      ------------------------------------------------------
      -- PROGRAMS / VARIABLES
      ------------------------------------------------------
      local terminal = "kitty"
      local fileManager = "nautilus"
      local browser = "zen"
      local browserNewWindow = "zen --blank-window"
      local browserPrivateWindow = "zen --private-window"
      local nextcloud = "firefox https://nextcloud.lndbl.de --new-window"
      local matrix = "https://matrix.tum.de/#/home"
      local music = "feishin"
      local calendar = "https://nextcloud.home/apps/calendar"
      local mail = "https://nextcloud.home/apps/mail"
      local japanese = "fcitx5 --enable mozc"
      local trilium = "trilium"
      local xournalpp = "xournalpp ~/Templates/xournalpp_template.xopp"
      local menu = "caelestia:launcher"
      local mainMod = "SUPER"

      ------------------------------------------------------
      -- AUTOSTART
      ------------------------------------------------------
      hl.on("hyprland.start", function()
        hl.exec_cmd(japanese)
      end)

      ------------------------------------------------------
      -- ENVIRONMENT
      ------------------------------------------------------
      hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

      ------------------------------------------------------
      -- LOOK AND FEEL
      ------------------------------------------------------
      hl.config({
        general = {
          gaps_in = 2.5,
          gaps_out = 5,
          border_size = 2,
          resize_on_border = false,
          allow_tearing = false,
          layout = "dwindle",
          col = {
            active_border = { colors = { "rgba(cba6f7ee)", "rgba(89b4faee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
          },
        },
        decoration = {
          rounding = 15,
          active_opacity = 1.0,
          inactive_opacity = 1.0,
          shadow = { enabled = false },
          blur = {
            enabled = true,
            size = 5,
            passes = 2,
            vibrancy = 0.5,
          },
        },
        animations = {
          enabled = true,
        },
        dwindle = { preserve_split = true },
        master = { new_status = "master" },
        misc = {
          force_default_wallpaper = 0,
          disable_hyprland_logo = true,
          allow_session_lock_restore = true,
        },
        ecosystem = { no_update_news = true },
      })

      -- Bezier curves (used for fades/layers/borders -- snappy, no overshoot)
      hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
      hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
      hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
      hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

      -- Spring curves (used for windows -- gives a bit of bounce/overshoot)
      hl.curve("windowSpring", { type = "spring", mass = 0.8, stiffness = 170, dampening = 18 })
      hl.curve("snappySpring", { type = "spring", mass = 0.7, stiffness = 220, dampening = 20 })

      hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows", enabled = true, speed = 10, spring = "windowSpring" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "snappySpring", style = "popin 80%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.8, bezier = "easeInOutCubic", style = "popin 80%" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 4.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 4.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade", enabled = true, speed = 8.03, bezier = "quick" })
      hl.animation({ leaf = "layers", enabled = true, speed = 8.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 4.5, bezier = "linear", style = "fade" })
      hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 4.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 4.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5.4, spring = "snappySpring", style = "slidefade 15%" })
      hl.animation({ leaf = "workspacesIn", enabled = true, speed = 4.6, bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 4.6, bezier = "easeOutQuint", style = "fade" })

      -- VERIFY: "borderangle" isn't in the confirmed leaf list, but existed in
      -- classic hyprlang for a continuously-rotating gradient border. Worth
      -- trying -- if Hyprland rejects the leaf name, just drop this block.
      hl.animation({ leaf = "borderangle", enabled = true, speed = 40, bezier = "linear", style = "loop" })

      ------------------------------------------------------
      -- INPUT
      ------------------------------------------------------
      hl.config({
        input = {
          kb_layout = "de",
          follow_mouse = 1,
          sensitivity = 0,
          touchpad = { natural_scroll = false },
        },
      })

      hl.device({
        name = "epic-mouse-v1",
        sensitivity = -0.5,
      })

      hl.config({
        xwayland = {
          force_zero_scaling = true,
        },
      })

      ------------------------------------------------------
      -- CAELESTIA DYNAMIC BORDER COLORS
      --
      -- caelestia-cli has a `theme.enableHypr` toggle in ~/.config/caelestia/cli.json
      -- that generates a colors file for Hyprland whenever you run
      -- `caelestia scheme set` / change your wallpaper. Find where it currently
      -- writes that file with:
      --   caelestia scheme set -n dynamic
      --   find ~/.cache/caelestia ~/.local/state/caelestia ~/.config/caelestia -newer /tmp -type f 2>/dev/null
      -- (their own hyprland config moved to Lua recently too, so the output is
      -- probably a small .lua file returning a colors table, not a .conf you'd
      -- source -- but confirm the shape once you find it.)
      --
      -- Once you know the path, something like this will pick up new colors on
      -- every `hyprctl reload` without you needing to edit this file again:
      --
      -- local ok, caelestiaColors = pcall(require, "caelestia-colors")
      -- if ok and caelestiaColors then
      --   hl.config({
      --     general = {
      --       ["col.active_border"] = caelestiaColors.active or "rgba(cba6f7ee) rgba(89b4faee) 45deg",
      --       ["col.inactive_border"] = caelestiaColors.inactive or "rgba(595959aa)",
      --     },
      --   })
      -- end
      --
      -- If caelestia's own postHook/theme step already runs `hyprctl reload`
      -- after generating the file, this just works automatically on scheme
      -- change -- no extra plumbing needed on your end beyond the require above.
      ------------------------------------------------------

      ------------------------------------------------------
      -- KEYBINDINGS
      ------------------------------------------------------

      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mainMod .. " + X", hl.dsp.layout("togglesplit"))

      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

      hl.bind(mainMod .. " + SPACE", hl.dsp.global(menu))

      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd(fileManager))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
      hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(browserNewWindow))
      hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(browserPrivateWindow))
      hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(xournalpp))
      hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(trilium))
      hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd(nextcloud))
      hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("grimblast save area ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"))

      -- Resize
      hl.bind(mainMod .. " + ALT + h", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
      hl.bind(mainMod .. " + ALT + l", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
      hl.bind(mainMod .. " + ALT + j", hl.dsp.window.resize({ x = 0, y = 100, relative = true  }))
      hl.bind(mainMod .. " + ALT + k", hl.dsp.window.resize({ x = 0, y = -100, relative = true  }))

      -- Move focus
      hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

      -- Switch workspaces / move window to workspace with mainMod (+ SHIFT) + [0-9]
      for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Move window within workspace
      hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

      -- Scratchpad
      hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

      -- Mouse workspace scrolling
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- Move/resize windows by dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Multimedia keys
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    '';
  };
}
