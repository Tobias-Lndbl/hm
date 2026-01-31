# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{
  #imports = [];

  options = {
    # Bootloader. boot.loader = {
      #systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };

    networking.hostName = "inari"; # Define your hostname.
    networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

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

    system.stateVersion = "25.05"; # Did you read the comment?
  };

  config = {
    config.appearance.hasBattery = true;
  };
}
