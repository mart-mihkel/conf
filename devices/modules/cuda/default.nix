{ pkgs, ... }:

{
  imports = [
    ./cachix.nix
    ./gpu.nix
  ];

  nixpkgs.config = {
    cudaSupport = true;
    allowUnfree = true;
  };

  environment = {
    systemPackages = with pkgs.cudaPackages; [
      cudatoolkit
      cudnn
    ];

    variables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib:$NIX_LD_LIBRARY_PATH";
      CUDA_HOME = "/run/opengl-driver";
    };
  };
}
