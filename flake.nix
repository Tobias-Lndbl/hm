{
  description = "Home Manager configuration of tbsl";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
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
      packages = forAllSystems (
        system: 
        let 
          pkgs = nixpkgs.legacyPackages.${system};
        in 
        import ./pkgs {inherit pkgs;}
        );


      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # -----------------------------------------------
      #                   nix-gt 
      # -----------------------------------------------     
      nixosConfigurations.nix-gt = nixpkgs.lib.nixosSystem  {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./nixos/wm/hyprland.nix
        ]; # ++ import ./modules/nixos;
      };

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
                ./hyprland/default.nix
              ];
          };
        };
    };
}
