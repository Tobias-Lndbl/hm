# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;



  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  security.pki.certificateFiles = [
    ./eos.pem
  ];

  security.rtkit.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  console.keyMap = "de";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # Enable the GNOME Desktop Environment.

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
  };

  services.displayManager.plasma-login-manager.enable = false;
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false;
  services.auto-cpufreq.enable = false;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

##NETWORKING##
  networking.firewall = {
    enable = true;
    logReversePathDrops = true;
    checkReversePath = false;
    allowedUDPPorts = [ 52193 ];
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.resolved.enable = false;

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 2;
  };
##


##PROGRAMS##
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };

    firefox.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib

        # Add any missing dynamic libraries for unpackaged programs
        # here, NOT in environment.systemPackages
      ];
    };
  };
##

  hardware.logitech.wireless.enable = true;

  hardware.i2c.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  services.ipp-usb.enable = true;

  users.users.tbsl = {
    isNormalUser = true;
    description = "tobias lindbuechl";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "scanner"
      "networkmanager"
      "docker"
      "dialout"
    ];
    #packages = with pkgs; [
    #];
  };

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pulseaudio
    dnsutils

    #hyprlock
    hyprpaper
    hypridle
    htop-vim

    brightnessctl
    ddcutil

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    sddm-astronaut

    man-pages
    man-pages-posix
  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      font-awesome
      roboto-mono
      roboto
      roboto-flex
      nerd-fonts.caskaydia-mono
    ];

    fontDir.enable = true;
  };

  console = {
    enable = true;
    packages = with pkgs; [
      roboto-mono
      roboto
      fira-code
      dina-font
      font-awesome
    ];
  };

  documentation.dev.enable = true;
  documentation.man.enable = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
  };
}
