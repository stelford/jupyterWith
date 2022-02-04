{
  description = "Your jupyterWith project";

  inputs.nixpkgs.follows = "jupyterWith/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";

  # inputs.jupyterWith.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , jupyterWith
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues jupyterWith.overlays;
      };

      iPython = pkgs.jupyterWith.kernels.iPythonWith {
        name = "Python-data-env";
        ignoreCollisions = true;
        packages = p: [
          p.numpy
        ];
      };

      iHaskell = pkgs.jupyterWith.kernels.iHaskellWith {
        name = "ihaskell-flake";
        packages = p: with p; [ vector aeson ];
        extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
        haskellPackages = pkgs.haskellPackages;
      };

      jupyterEnvironment =
        pkgs.jupyterWith.jupyterlabWith {
          kernels = [
            iPython
            iHaskell
          ];
        };
    in rec {
      defaultPackage = packages.jupyterEnvironment;
      packages = { inherit jupyterEnvironment; };
    });
}
