{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      libraries = with pkgs; [
        mesa
        libGL
        libGLU
        cairo
        libglvnd
        glib
        glib-networking
        gtk3
        gtk4
        libxkbcommon
        fontconfig
        freetype
        webkitgtk
        xorg.libX11
        dbus
        zlib
        qt6.qtbase
        python311Packages.tkinter
        python312Packages.pygobject3
        gobject-introspection
      ];
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = libraries;
        
        shellHook = ''
          export LD_LIBRARY_PATH=$(realpath ./nodegui/miniqt/6.6.0/gcc_64/lib):${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
        '';
      };
    }
  );
}
