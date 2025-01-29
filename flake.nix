{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, sops-nix, home-manager, ... }: let
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
        modules = kubujuss ++ [ ./devices/dell ];
      };

      jaam = nixpkgs.lib.nixosSystem {
        system = "${x86}";
        modules =  kubujuss-headless ++ [ ./devices/jaam ];
      };

      alajaam = nixpkgs.lib.nixosSystem {
        system = "${arm}";
        modules = kubujuss-headless ++ [
          sops-nix.nixosModules.sops
          ./devices/alajaam 
        ];
      };
    };
  };
}
