{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: let
    x86 = "x86_64-linux";
    arm = "aarch64-linux";

    kubujuss = make-users { kubujuss = import ./homes/kubujuss.nix; };
    kubujuss-headless = make-users { kubujuss = import ./homes/kubujuss-headless.nix; };

    make-users = users: [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          inherit users;
        };
      }
    ];
  in {
    nixosConfigurations = {
      dell = nixpkgs.lib.nixosSystem {
        system = "${x86}";
        modules = [ ./devices/dell ] ++ kubujuss;
      };

      jaam = nixpkgs.lib.nixosSystem {
        system = "${x86}";
        modules = [ ./devices/jaam ] ++ kubujuss-headless;
      };

      alajaam = nixpkgs.lib.nixosSystem {
        system = "${arm}";
        modules = [ ./devices/alajaam ] ++ kubujuss-headless;
      };
    };
  };
}
