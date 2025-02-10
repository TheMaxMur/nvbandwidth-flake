{ stdenv
, fetchgit
, cmake
, cudatoolkit
, gcc13
, cudaPackages
, boost183
, python313Packages
, linuxKernel
}:

stdenv.mkDerivation rec {
  name = "nvbandwidth";
  version = "0.7";

  src = fetchgit {
    url = "https://github.com/NVIDIA/nvbandwidth";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ph4Gyjod5uFwHOg6jG0AvMjfDdqKgZa1aEczjA3gHbo=";
  };

  outputs = [ "out" "bin" ];

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-Wno-dev"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail 'set(Boost_USE_STATIC_LIBS ON)' 'set(Boost_USE_STATIC_LIBS OFF)'
    substituteInPlace CMakeLists.txt --replace-fail 'file(READ "/etc/os-release" OS_RELEASE_CONTENT)' ' '
  '';

  nativeBuildInputs = [
    cmake 
    boost183
    cudatoolkit
    gcc13
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    cudaPackages.libcublas
    python313Packages.nvidia-ml-py
    linuxKernel.packages.linux_zen.nvidia_x11_latest
  ];

  installPhase = ''
    ls -la
    cp nvbandwidth "$bin"
  '';
}
