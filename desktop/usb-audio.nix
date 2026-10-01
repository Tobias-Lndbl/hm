{ ... }:

# Fix for the onboard "Generic USB Audio" card on amaterasu (MSI 0db0:422d)
# coming up muted on every boot.
#
# WirePlumber's ALSA monitor sets api.alsa.use-acp = true by default, which
# routes the card through the ACP device factory. ACP probes the card's
# HiFi/pro-audio profiles at startup, and probing mutes every
# 'PCM Playback Switch' element. The card then settles on a profile with no
# mixer paths, so ACP never unmutes them again -- the card stays silent.
#
# Disabling ACP for this one card makes WirePlumber use the plain
# api.alsa.device factory: the raw PCMs are exposed and the hardware mixer is
# left untouched. Scoped by device.name, so it is inert on the other hosts.
#
# Side effect: the sink names lose their ACP profile prefix,
# alsa_output.<card>.pro-output-N becomes alsa_output.<card>.playback.N.0.

{
  xdg.configFile."wireplumber/wireplumber.conf.d/51-usb-audio-raw.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.usb-Generic_USB_Audio-00"
          }
        ]
        actions = {
          update-props = {
            api.alsa.use-acp = false
          }
        }
      }
    ]
  '';
}
