{ pkgs ? import <nixpkgs> {}, compiler ? "ghc865", doBenchmark ? true }:
let
  fontsConf = pkgs.makeFontsConf {
    fontDirectories = [ pkgs.cantarell-fonts ];
  };
  haskellPackages = pkgs.haskell.packages.${compiler};
  project = import ./. { inherit compiler doBenchmark; };
in
  haskellPackages.shellFor {
    withHoogle = true;
    packages = p: [
      project.gi-gtk-declarative
      project.gi-gtk-declarative-app-simple
      project.examples
    ];
    buildInputs = [
      project.docs.packages.mkdocs
      project.docs.packages.mkdocs-material
    ];
    FONTCONFIG_FILE = fontsConf;
  }
