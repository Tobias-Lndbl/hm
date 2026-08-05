{
  description = "Home Manager configuration of tbsl";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      hm,
      caelestia-shell,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";

      mkHome =
        extraModules:
        hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home.nix
            caelestia-shell.homeManagerModules.default
          ]
          ++ (import ./modules/hm)
          ++ extraModules;
        };

    in
    rec {
      inherit system;
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = import ./overlays { inherit inputs; };

      # -----------------------------------------------
      #                  home-config
      # -----------------------------------------------
      homeConfigurations = {
        "tbsl@amaterasu" = mkHome [ ./nixos/hyprland/amaterasu_hyprland.nix ];
        "tbsl@izanagi" = mkHome [ ];
        "tbsl@inari" = mkHome [ ./nixos/hyprland/inari_hyprland.nix ];
        "tbsl" = mkHome [ ];
      };

      # -----------------------------------------------
      #                  amaterasu-config
      # -----------------------------------------------
      nixosConfigurations."amaterasu" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/amaterasu/configuration.nix
          ./nixos/nix_conf/amaterasu/hardware-configuration.nix
          ./nixos/wireguard/wireguard.nix

        ];
      };

      # -----------------------------------------------
      #                  izanagi-config
      # -----------------------------------------------
      nixosConfigurations."izanagi" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/izanagi/configuration.nix
          ./nixos/nix_conf/izanagi/hardware-configuration.nix
          ./nixos/wireguard/wireguard.nix

        ];
      };

      # -----------------------------------------------
      #                  inari-config
      # -----------------------------------------------
      nixosConfigurations."inari" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/inari/configuration.nix
          ./nixos/nix_conf/inari/hardware-configuration.nix
          ./nixos/wireguard/wireguard.nix

        ];
      };
    };
}
