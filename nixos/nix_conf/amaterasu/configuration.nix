# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:
{

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      theme = pkgs.stdenv.mkDerivation {
        pname = "sekiro-grub-theme";
        version = "1.0";
        src = pkgs.fetchFromGitHub {
          owner = "AbijithBalaji";
          repo = "sekiro_grub_theme";
          # Full commit hash to avoid 404
          rev = "66f7f287310034a78107779f7435f30863071871";
          # This is the correct SRI hash for this repo
          hash = "sha256-uXwDjb0+ViQvdesG5gefC5zFAiFs/FfDfeI5t7vP+Qc=";
        };
        installPhase = ''
          mkdir -p $out
          cp -r Sekiro/* $out
        '';
      };
    };
  };
  networking.hostName = "amaterasu"; # Define your hostname.
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];
  boot.kernelModules = [ "nct6687" ];

  boot = {
    kernelParams = [
      # To allow cooler control
      "nvidia.NVreg_RestrictProfilingToAdminUsers=0"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia_modeset.disable_vrr_memclk_switch=1"
      # for suspend/wakeup issues, recommended by https://wiki.hyprland.org/Nvidia/
      # (redundant since powerManagement.enable also sets this, kept for intent)
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      # for wayland issues, but breaks tty
      # see https://github.com/NixOS/nixpkgs/issues/343774#issuecomment-2370293678
      # "initcall_blacklist=simpledrm_platform_driver_init"

      # Physical block offset of the first extent of /var/lib/swapfile.
      # Required to resume from hibernation off a swapfile on ext4.
      # Regenerate with scripts/hibernate-swapfile.sh if the swapfile is ever
      # recreated, resized or moved -- a stale value silently means "no resume".
      "resume_offset=63727616"
    ];
  };

  # ---------------------------------------------------------------------
  # HIBERNATION
  # ---------------------------------------------------------------------
  # 34 GiB swapfile on the ext4 root -- has to be >= RAM in use (32 GiB
  # installed), and the hibernation image is compressed, so this is roomy.
  # NixOS creates it with dd, so it is fully allocated and its physical offset
  # stays put, which is what resume_offset above relies on.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 34816; # MiB
    }
  ];

  # The filesystem holding the swapfile. Offset comes from resume_offset above.
  boot.resumeDevice = "/dev/disk/by-uuid/76639061-d51f-4ad9-9427-9ddce654d149";

  # The MT7922's PCIe WiFi half times out on the resume side of a hibernation
  # cycle, leaving wlp13s0 dead until the module is reloaded:
  #   mt7921e 0000:0d:00.0: Message 00020007 (seq 10) timeout
  #   mt7921e 0000:0d:00.0: PM: dpm_run_callback(): pci_pm_restore returns -110
  #   mt7921e 0000:0d:00.0: PM: failed to restore async: error -110
  # wlp13s0 is down and unused here (wired enp12s0 + wireguard), and the card's
  # Bluetooth half is a separate USB device on btusb, so dropping the module
  # around sleep costs nothing and keeps BT working.
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/modprobe -r mt7921e || true
  '';
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/modprobe mt7921e || true
  '';

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    gsp.enable = config.hardware.nvidia.open;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    # Driver 595 + open modules defaults this to true, which hands suspend/resume
    # VRAM save/restore to an in-kernel PM notifier. On this box that notifier
    # stalled between "PM: suspend entry" and "Freezing user space processes" for
    # 19s (2026-09-10), 6min14s (2026-09-27) and indefinitely (2026-08-23, had to
    # be hard-reset). Forcing it off goes back to the long-standing
    # nvidia-suspend/-hibernate/-resume systemd services instead.
    # Flip back to true to A/B it once hibernation is otherwise healthy.
    powerManagement.kernelSuspendNotifier = false;
    #    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #      version = "570.124.04";
    #      sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
    #      openSha256 = "sha256-KCGUyu/XtmgcBqJ8NLw/iXlaqB9/exg51KFx0Ta5ip0=";
    #      settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
    #      persistencedSha256 = "";
    #      usePersistenced = true;
    #    };
  };

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  #services.logind.powerKey = "suspend";

  # Override defaultConf.nix's HandlePowerKey = "suspend" for amaterasu only.
  # While sleep is unreliable here a power-button press is actively harmful: it
  # registers as a wakeup event that rolls back an in-progress hibernation (even
  # after the image is fully written), and it routes into the broken S3 path.
  # A clean shutdown is the useful behaviour on a desktop in that state.
  # Set back to "suspend" once hibernation and S3 are both trustworthy.
  services.logind.settings.Login.HandlePowerKey = lib.mkForce "poweroff";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  programs.gamemode.enable = true;

  programs.coolercontrol.enable = true;
  #programs.coolercontrol.nvidiaSupport = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  #lg steering wheel:
  hardware.new-lg4ff.enable = true;
  services.udev.packages = with pkgs; [ oversteer ];

  # The box used to come straight back out of S3 within ~1s of entering it, with
  # "pcieport 0000:00:02.1: PME: Spurious native interrupt!" on resume. The
  # Realtek NIC is not PCI-wakeup-enabled, so this is not Wake-on-LAN; the only
  # wake-enabled devices left are USB.
  #
  # 046d:c547 is the Lightspeed receiver for the PRO X Wireless headset. A
  # headset is never a wake source, and its receiver chattering is a prime
  # suspect, so drop remote wakeup on it.
  #
  # Deliberately NOT touched: 046d:c548 (Bolt receiver -> MX Keys Mini + Logi POP
  # Mouse) and 32e3:00f2 (wired Mizar keyboard). Wakeup is per-receiver, so
  # silencing the Bolt one would also cost wake-by-keyboard. If S3 still wakes
  # instantly, the POP Mouse sharing that receiver is the next suspect -- add
  # c548 here and accept power-button-only wake. Moot for hibernation, where the
  # machine is off and only the power button can wake it anyway.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c547", ATTR{power/wakeup}="disabled"

    # Per-card ALSA state restore. Replaces the rule that
    # hardware.alsa.enablePersistence would install (see below); the only
    # difference is -L/--no-lock.
    ACTION=="add", SUBSYSTEM=="sound", KERNEL=="controlC*", KERNELS!="card*", GOTO="alsa_restore_nolock_go"
    GOTO="alsa_restore_nolock_end"

    LABEL="alsa_restore_nolock_go"
    RUN+="${pkgs.alsa-utils}/bin/alsactl restore -gUL $attr{device/number}"
    LABEL="alsa_restore_nolock_end"
  '';

  services.pipewire.extraConfig.pipewire."99-force-surround" = {
    "context.modules" = [
      {
        name = "libpipewire-module-spa-device-factory";
        args = { };

      }
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alsa-plugins
    alsa-utils
    oversteer
  ];

  # Explicitly link the A52 encoder so PipeWire/ALSA can use it
  environment.etc = {
    "alsa/conf.d/60-a52-encoder.conf".source =
      "${pkgs.alsa-plugins}/etc/alsa/conf.d/60-a52-encoder.conf";
    "alsa/conf.d/59-a52-lib.conf".text = ''
      pcm_type.a52 {
        lib "${pkgs.alsa-plugins}/lib/alsa-lib/libasound_module_pcm_a52.so"
      }
    '';
  };

  # ALSA state persistence, hand-rolled instead of hardware.alsa.enablePersistence.
  #
  # The upstream option's udev rule runs `alsactl restore -gU` *with* locking. At
  # coldplug, systemd-tmpfiles has not yet created /run/lock (the target of the
  # /var/lock symlink), so alsactl cannot create its lock file and aborts with
  # ENOENT before reading any state -- every card failed on every boot:
  #   controlC0..C6: Process '.../alsactl restore -gU <N>' failed with exit code 2
  # The global restore in alsa-store.service papered over this, since it is ordered
  # after sysinit.target and therefore after tmpfiles. But a card that registers
  # after that service has already run got no state restored at all until the next
  # boot, and the USB cards here finish enumerating only ~200ms before it.
  #
  # So: option off, udev rule reinstated above with -L/--no-lock (which skips
  # locking entirely and works during coldplug), and the store/restore service
  # copied from nixos/modules/services/audio/alsa.nix unchanged -- it runs late
  # enough that /run/lock exists, so it keeps its locking.
  hardware.alsa.enablePersistence = false;

  systemd.services.alsa-store = {
    description = "Store Sound Card State";
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
    unitConfig = {
      RequiresMountsFor = "/var/lib/alsa";
      ConditionVirtualization = "!systemd-nspawn";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StateDirectory = "alsa";
      # Note: the service should never be restarted, otherwise any setting
      # changed between the last `store` and now will be lost. To prevent NixOS
      # from starting it in case it has failed we expand the exit codes
      # considered successful.
      SuccessExitStatus = [
        0
        99
      ];
      ExecStart = "${pkgs.alsa-utils}/bin/alsactl restore -gU";
      ExecStop = "${pkgs.alsa-utils}/bin/alsactl store -gU";
    };
  };



  ##GAMES

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glib
    gtk3
    webkitgtk_4_1
    libsoup_3
  ];

  
  security.unprivilegedUsernsClone = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
