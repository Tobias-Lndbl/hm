{
  description = "Home Manager configuration of tbsl";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

    in
    rec {
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = import ./overlays { inherit inputs; };

      # -----------------------------------------------
      #                  home-config
      # -----------------------------------------------
      homeConfigurations = {
        "tbsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home.nix
	    stylix.homeModules.stylix
          ];
        };
      };

      # -----------------------------------------------
      #                  amaterasu-config
      # -----------------------------------------------
      nixosConfigurations."amaterasu" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/amaterasu/configuration.nix
          ./nixos/nix_conf/amaterasu/hardware-configuration.nix

        ];
      };

      # -----------------------------------------------
      #                  izanagi-config
      # -----------------------------------------------
      nixosConfigurations."izanagi" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/izanagi/configuration.nix
          ./nixos/nix_conf/izanagi/hardware-configuration.nix

        ];
      };

      # -----------------------------------------------
      #                  inari-config
      # -----------------------------------------------
      nixosConfigurations."inari" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/nix_conf/defaultConf.nix
          ./nixos/nix_conf/inari/configuration.nix
          ./nixos/nix_conf/inari/hardware-configuration.nix

        ];
      };
    };
}
