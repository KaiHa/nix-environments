{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/68ef4b14bcea2ae024996ebcaac399abdd4c1074.tar.gz) {} }:

let
  # Downgrade curl to 7.55.1
  my-curl = (import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/22ff01f651611dde11d60541b8af76b2ac19ff0d.tar.gz) {}).curl;
  my-jdk = pkgs.openjdk8.override { minimal = true; };
  my-python = pkgs.python2.withPackages (p: with p; [ Mako ] );
  fhs = pkgs.buildFHSUserEnv {
    name = "android-env";
    targetPkgs = pkgs: with pkgs; [
      androidenv.buildTools
      androidenv.platformTools
      bc
      binutils
      bison
      ccache
      coreutils
      flex
      gcc5
      gdb
      gettext
      git
      gitRepo
      glibc
      glibc.static
      gnumake
      gnupg1compat
      gperf
      libxml2
      lzop
      m4
      my-curl
      my-jdk
      my-python
      ncurses5
      nettools
      openssl
      perl
      procps
      rsync
      schedtool
      unzip
      utillinux
      which
      zip
    ];
    multiPkgs = pkgs: with pkgs; [ zlib ];
    extraOutputsToInstall = [ "dev" ];
    runScript = "bash";
    profile = ''
      export USE_CCACHE=1
      export ANDROID_JAVA_HOME=${my-jdk.home}
      export LANG=C
      export USER=$(whoami)
      unset _JAVA_OPTIONS
      export BUILD_NUMBER=$(date --utc +%Y.%m.%d.%H.%M.%S)
      export DISPLAY_BUILD_NUMBER=true
    '';
  };
in fhs.env
