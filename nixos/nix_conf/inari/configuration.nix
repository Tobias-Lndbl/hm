# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{

  # Bootloader.
  boot.loader = {
    #systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;

      #theme = pkgs.stdenv.mkDerivation {
      #  pname = "sekiro-grub-theme";
      #  version = "1.0";
      #  src = pkgs.fetchFromGitHub {
      #    owner = "AbijithBalaji";
      #    repo = "sekiro_grub_theme";
      # Full commit hash to avoid 404
      #    rev = "66f7f287310034a78107779f7435f30863071871"; 
      # This is the correct SRI hash for this repo
      #    hash = "sha256-uXwDjb0+ViQvdesG5gefC5zFAiFs/FfDfeI5t7vP+Qc=";
      #  };
      #  installPhase = ''
      #    mkdir -p $out
      #    cp -r Sekiro/* $out
      #  '';
      #};
    };
  };

  networking.hostName = "inari"; # Define your hostname.
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #services.logind.powerKey = "suspend";

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "de";
  #  variant = "";
  #};

  # Configure console keymap
  # console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #services.pulseaudio.enable = true;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  #};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
    jdk
    iio-sensor-proxy
    iio-hyprland
    jq
  ];


  hardware.sensor.iio.enable = true;

  services.upower.enable = true;

  config.appearance.hasBattery = true;
  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
