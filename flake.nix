{
  description = "HSRTReport - Typst report template of Reutlingen University";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        rec {
          default = document;

          # The example document in src/, compiled to build/main.pdf.
          document = pkgs.stdenvNoCC.mkDerivation {
            pname = "hsrtreport-document";
            version = "1.0.0";
            src = self;
            nativeBuildInputs = [ pkgs.typst ];
            buildPhase = ''
              typst compile \
                --root . \
                --font-path hsrtreport/assets/fonts \
                src/main.typ main.pdf
            '';
            installPhase = ''
              install -Dm644 main.pdf $out/main.pdf
            '';
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.typst
              pkgs.tinymist
              pkgs.gnumake
              (pkgs.python3.withPackages (ps: [ ps.fonttools ]))
            ];
            shellHook = ''
              echo "typst $(typst --version | cut -d' ' -f2) - run 'make' to build src/main.typ"
            '';
          };
        });

      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);
    };
}
