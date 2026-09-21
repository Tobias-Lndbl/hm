# Edit this configuration file to define what should be installed on
# your system.
# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  ##############################
  # add for eist retake        #
  ##############################
  #virtualisation.docker.enable = true;
  #users.users.tbsl.extraGroups = [ "docker" ];

  ##BOOTLOADER##
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 3;
    };
  };

  networking.hostName = "inari"; # Define your hostname.

  ##NETWORKING##
  networking = {
    networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];

    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
    networkmanager.wifi.macAddress = "preserve";
    enableIPv6 = false;

  };

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
    batmon
  ];

  hardware.sensor.iio.enable = true;
  services.upower.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
