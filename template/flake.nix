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
        overlays = [
          jupyterWith.overlays.jupyterWith
        ];
      };
      jupyterEnvironment =
        pkgs.jupyterWith.jupyterlabWith {
          kernels = [];
        };
    in rec {
      defaultPackage = packages.jupyterEnvironment;
      packages = { inherit jupyterEnvironment; };
    });
}
