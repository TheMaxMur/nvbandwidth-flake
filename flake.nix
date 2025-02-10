{
  description = "nvbandwidth flake";

  inputs = {
    # Official NixOS repo
    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Current nixpkgs branch
    nixpkgs = {
      follows = "unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };

        packages = {
          nvbandwidth = pkgs.callPackage ./pkgs/nvbandwidth.nix {};
        };
      };
    };
}
