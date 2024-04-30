{
  description = "A Nix-flake-based Python development environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          name = "impurePythonEnv";
          buildInputs = [
              pkgs.python311
              pkgs.python311Packages.venvShellHook
              pkgs.imagemagick
              pkgs.python311Packages.python-lsp-server
              pkgs.python311Packages.python-lsp-ruff
          ];
          venvDir = ".venv";
          postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          pip install -r requirements.txt
          '';
          shellHook = ''
            unset SOURCE_DATE_EPOCH
          '';
        };
      });
    };
}
