{
  description = "Home Manager configuration of tbsl";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    ... 
  }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux"];

    in 
    rec {
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

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
              ];
          };
        };

      # -----------------------------------------------
      #                  izanagi-config
      # -----------------------------------------------
        nixosConfigurations."izanagi" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
           # ./nixos/nix_conf/defaultConf.nix
            ./nixos/nix_conf/izanagi/configuration.nix
            ./nixos/nix_conf/izanagi/hardware-configuration.nix


          ];
        };
    };
}
