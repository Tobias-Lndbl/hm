{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  xdg.configFile."caelestia/shell.json".force = true;
  xdg.configFile."caelestia/cli.json".force = true;

  home.activation.caelestiaMutableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for f in "$HOME/.config/caelestia/shell.json"; do
      if [ -L "$f" ]; then
        target=$(readlink -f "$f")
        rm "$f"
        cp "$target" "$f"
        chmod u+w "$f"
      fi
    done
  '';

  xdg.configFile."caelestia/templates/kitty.conf".text = ''
    foreground #{{ onSurface.hex }}
    background #{{ surface.hex }}
    cursor #{{ secondary.hex }}
    selection_background #{{ secondary.hex }}
    color0 #{{ term0.hex }}
    color1 #{{ term1.hex }}
    color2 #{{ term2.hex }}
    color3 #{{ term3.hex }}
    color4 #{{ term4.hex }}
    color5 #{{ term5.hex }}
    color6 #{{ term6.hex }}
    color7 #{{ term7.hex }}
  '';

  xdg.configFile."caelestia/templates/caelestia-colors.lua".text = ''
    return {
      active_colors = { "rgba({{ primary.hex }}ee)", "rgba({{ secondary.hex }}ee)" },
      active_angle = 45,
      inactive = "rgba({{ surfaceVariant.hex }}aa)"
    }
  '';

  xdg.configFile."caelestia/templates/base16-nvim.lua".text = ''
    return {
      base00 = '#{{ background.hex }}',
      base01 = '#{{ surfaceContainerLow.hex }}',
      base02 = '#{{ surfaceContainer.hex }}',
      base03 = '#{{ outline.hex }}',
      base04 = '#{{ subtext0.hex }}',
      base05 = '#{{ onSurface.hex }}',
      base06 = '#{{ onBackground.hex }}',
      base07 = '#{{ text.hex }}',
      base08 = '#{{ red.hex }}',
      base09 = '#{{ peach.hex }}',
      base0A = '#{{ yellow.hex }}',
      base0B = '#{{ green.hex }}',
      base0C = '#{{ teal.hex }}',
      base0D = '#{{ blue.hex }}',
      base0E = '#{{ mauve.hex }}',
      base0F = '#{{ maroon.hex }}',
    }
  '';

  programs.caelestia = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./caelestia_settings.json);

    # -----------------------------------------------------
    # CAELESTIA SHELL PACKAGE OVERRIDE (QML PATCHING)
    # -----------------------------------------------------
    package =
      inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
        (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace modules/utilities/cards/Record.qml \
              --replace-fail 'import qs.services' 'import Quickshell
                    import qs.services' \
              --replace-fail '                        onClicked: Recorder.start(["-sr"])
                                }
                            ]
                        }
                    }' '                        onClicked: Recorder.start(["-sr"])
                                }
                            ]
                        }

                        IconButton {
                            shapeMorph: true
                            isRound: true
                            icon: "photo_camera"
                            type: IconButton.Tonal
                            font: Tokens.font.icon.medium
                            onClicked: {
                                root.screenState.utilities = false;
                                Quickshell.execDetached(["sh", "-c", "sleep 0.3 && grimblast copy area"]);
                            }

                            implicitWidth: {
                                const h = label.implicitHeight + Tokens.padding.large * 2;
                                if (h % 2 !== 0) return h + 1;
                                return h;
                            }
                        }
                    }'

            substituteInPlace modules/session/Content.qml \
              --replace-fail '    AnimatedImage {
                    width: Tokens.sizes.session.button
                    height: Tokens.sizes.session.button
                    sourceSize.width: width * ((QsWindow.window as QsWindow)?.devicePixelRatio ?? 1)

                    playing: visible
                    asynchronous: true
                    speed: Config.general.sessionGifSpeed
                    source: Paths.absolutePath(Config.paths.sessionGif)
                    fillMode: AnimatedImage.PreserveAspectFit
                }' '    Item {}' \
              --replace-fail '    SessionButton {
                    id: logout

                    icon: Config.session.icons.logout
                    command: Config.session.commands.logout

                    KeyNavigation.down: shutdown' '    SessionButton {
                    id: lock

                    icon: "lock"
                    command: ["caelestia-shell", "ipc", "call", "lock", "lock"]

                    KeyNavigation.down: logout
                }

                SessionButton {
                    id: logout

                    icon: Config.session.icons.logout
                    command: Config.session.commands.logout

                    KeyNavigation.up: lock
                    KeyNavigation.down: shutdown'

            substituteInPlace modules/sidebar/NotifActionList.qml \
              --replace-fail 'action.modelData.invoke();' 'action.modelData.invoke(); Quickshell.execDetached(["hyprctl", "dispatch", "focuswindow", "class:^(?i)" + root.notif.appName + "$"]);'

            substituteInPlace modules/bar/components/workspaces/Workspace.qml \
              --replace-fail '    Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: size' '    visible: root.isOccupied || root.activeWsId === root.ws
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: size'

            substituteInPlace modules/dashboard/dash/DateTime.qml \
              --replace-fail '            text: Time.minuteStr
                        color: Colours.palette.m3secondary
                        font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
                    }

                    Loader {' '            text: Time.minuteStr
                        color: Colours.palette.m3secondary
                        font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: Time.format("ss")
                        color: Colours.palette.m3primary
                        font: Tokens.font.clock.size(18).weight(Font.DemiBold).build()
                    }

                    Loader {'

            substituteInPlace modules/dashboard/dash/DateTime.qml \
              --replace-fail '        spacing: 0

                    StyledText {
                        Layout.bottomMargin: -(font.pointSize * 0.4)
                        Layout.alignment: Qt.AlignHCenter
                        text: Time.hourStr' '        spacing: 0

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: Time.format("dddd")
                        color: Colours.palette.m3primary
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 8
                        text: Time.format("MMM d")
                        color: Colours.palette.m3secondary
                    }

                    StyledText {
                        Layout.bottomMargin: -(font.pointSize * 0.4)
                        Layout.alignment: Qt.AlignHCenter
                        text: Time.hourStr'
          '';
        });

    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [ ];
    };

    cli = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./caelestia_cli.json);
      package =
        inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.system}.default.overrideAttrs
          (old: {
            postFixup = (old.postFixup or "") + ''
              schemedir=$(find $out -type d -path '*/caelestia/data/schemes' -print -quit)
              if [ -z "$schemedir" ]; then
                echo "ERROR: caelestia schemes directory not found in $out" >&2
                exit 1
              fi
              cp -r ${./schemes}/. "$schemedir/"
            '';
          });
    };
  };
}
