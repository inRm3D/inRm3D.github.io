{
  description = "inRm3D";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.stdenv.mkDerivation rec {
            pname = "inrm3d";
            version = "2.869";
            src = ./.;

            nativeBuildInputs = [
              pkgs.lazarus
              pkgs.makeWrapper
              pkgs.wrapGAppsHook
            ];

            buildInputs = [
              pkgs.fontconfig
              pkgs.freetype
              pkgs.gdk-pixbuf
              pkgs.glib
              pkgs.gtk2
              pkgs.xorg.libX11
              pkgs.xorg.libXcursor
              pkgs.xorg.libXext
              pkgs.xorg.libXrender
              pkgs.xorg.libXtst
            ];

            buildPhase = ''
              runHook preBuild
              if [ -f inRm3D.lpi ]; then
                srcdir="."
              elif [ -f src/inRm3D.lpi ]; then
                srcdir="src"
              else
                echo "inRm3D.lpi not found"
                exit 1
              fi
              (cd "$srcdir" && lazbuild -B inRm3D.lpi)
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              if [ -f inRm3D.lpi ]; then
                srcdir="."
              elif [ -f src/inRm3D.lpi ]; then
                srcdir="src"
              else
                echo "inRm3D.lpi not found"
                exit 1
              fi
              binpath="$srcdir/lib/${pkgs.stdenv.hostPlatform.system}/inRm3D"
              if [ ! -f "$binpath" ]; then
                binpath="$(find "$srcdir/lib" -maxdepth 2 -type f -name inRm3D | head -n 1)"
              fi
              if [ -z "$binpath" ] || [ ! -f "$binpath" ]; then
                echo "inRm3D binary not found under lib/"
                exit 1
              fi
              install -Dm755 "$binpath" "$out/lib/inRm3D/inRm3D"
              if [ -d "$srcdir/SubUnit" ]; then
                cp -r "$srcdir/SubUnit" "$out/lib/inRm3D/"
              fi
              if [ -d "$srcdir/Cursor" ]; then
                cp -r "$srcdir/Cursor" "$out/lib/inRm3D/"
              fi
              if [ -d "$srcdir/Image" ]; then
                cp -r "$srcdir/Image" "$out/lib/inRm3D/"
              fi
              makeWrapper "$out/lib/inRm3D/inRm3D" "$out/bin/inRm3D"
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "inRm3D";
              homepage = "https://github.com/inRm3D/inRm3D.github.io";
              license = licenses.unfree;
              platforms = platforms.linux;
            };
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/inRm3D";
        };
      });
    };
}
