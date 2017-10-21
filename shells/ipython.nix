{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  my_ipython = python3.withPackages (p: with p; [ ipython matplotlib jupyter pandas ] );
in stdenv.mkDerivation rec {
  name = "ipython-env";
  buildInputs = [ my_ipython ];
  env = buildEnv { name = name; paths = buildInputs; };
}
