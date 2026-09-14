{
  description = "HSRTReport - Typst report template of Reutlingen University";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      fonts = "src/assets/fonts";
      packageDir = "$HOME/.local/share/typst/packages/preview/hsrtreport/1.0.0";
    in
    {
      packages = forAllSystems (system:
        let pkgs = pkgsFor system; in
        rec {
          default = example;

          # The example document, compiled to $out/main.pdf.
          example = pkgs.stdenvNoCC.mkDerivation {
            pname = "hsrtreport-example";
            version = "1.0.0";
            src = self;
            nativeBuildInputs = [ pkgs.typst ];
            buildPhase = ''
              typst compile --font-path ${fonts} example/main.typ main.pdf
            '';
            installPhase = ''
              install -Dm644 main.pdf $out/main.pdf
            '';
          };
        });

      apps = forAllSystems (system:
        let
          pkgs = pkgsFor system;

          app = name: text: {
            type = "app";
            program = "${pkgs.writeShellApplication {
              inherit name text;
              runtimeInputs = [ pkgs.typst ];
            }}/bin/${name}";
          };
        in
        rec {
          default = build;

          # Compile the example document.
          build = app "build" ''
            typst compile --font-path ${fonts} example/main.typ build/main.pdf
          '';

          # Compile the example document on every change.
          watch = app "watch" ''
            typst watch --font-path ${fonts} example/main.typ build/main.pdf
          '';

          # Link the repository into the local Typst package directory, so that
          # `typst init @local/hsrtreport:1.0.0` and `@local` imports work.
          install = app "install" ''
            mkdir -p "$(dirname "${packageDir}")"
            ln -sfn "$PWD" "${packageDir}"
            echo "linked ${packageDir} -> $PWD"
          '';

          # Copy the template fonts into the font directory of the user. After
          # this, typst finds them without --font-path.
          install-fonts = app "install-fonts" ''
            target="$HOME/.local/share/fonts/hsrtreport"
            source="${fonts}"
            if [ ! -d "$source" ]; then
              source="${packageDir}/${fonts}"
            fi
            mkdir -p "$target"
            cp "$source"/*/*.ttf "$target"/
            if command -v fc-cache > /dev/null; then fc-cache -f "$target"; fi
            echo "installed the template fonts into $target"
          '';

          # Render the first page of the example document as the package
          # thumbnail.
          thumbnail = {
            type = "app";
            program = "${pkgs.writeShellApplication {
              name = "thumbnail";
              runtimeInputs = [ pkgs.typst pkgs.poppler-utils ];
              text = ''
                typst compile --font-path ${fonts} example/main.typ build/main.pdf
                pdftoppm -r 150 -png -f 1 -l 1 -singlefile build/main.pdf thumbnail
              '';
            }}/bin/thumbnail";
          };

          # Normalize the name tables of the bundled fonts.
          patch-fonts = {
            type = "app";
            program = "${pkgs.writeShellApplication {
              name = "patch-fonts";
              runtimeInputs = [ (pkgs.python3.withPackages (ps: [ ps.fonttools ])) ];
              text = ''python3 tools/patch-fonts.py ${fonts}'';
            }}/bin/patch-fonts";
          };
        });

      devShells = forAllSystems (system:
        let pkgs = pkgsFor system; in
        {
          default = pkgs.mkShell {
            packages = [ pkgs.typst pkgs.tinymist ];
            shellHook = ''
              echo "typst $(typst --version | cut -d' ' -f2)"
              echo "nix run .#build | .#watch | .#install | .#install-fonts"
            '';
          };
        });

      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);
    };
}
