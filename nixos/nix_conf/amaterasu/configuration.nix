# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };
  networking.hostName = "amaterasu"; # Define your hostname.
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
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      # for wayland issues, but breaks tty
      # see https://github.com/NixOS/nixpkgs/issues/343774#issuecomment-2370293678
      # "initcall_blacklist=simpledrm_platform_driver_init"
    ];
  };


hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    gsp.enable = config.hardware.nvidia.open;
    nvidiaSettings = true;
#    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#      version = "570.124.04";
#      sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
#      openSha256 = "sha256-KCGUyu/XtmgcBqJ8NLw/iXlaqB9/exg51KFx0Ta5ip0=";
#      settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
#      persistencedSha256 = "";
#      usePersistenced = true;
#    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  programs.gamemode.enable = true;


  programs.coolercontrol.enable = true;
  programs.coolercontrol.nvidiaSupport = true;

#  hardware.bluetooth = {
#    enable = true;
#    powerOnBoot = true;
#  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };  

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
