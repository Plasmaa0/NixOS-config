{
  pkgs,
  lib,
  colorsList,
  inputImage,
}: let
  # Determine output format using declarative mapping
  extension = let
    formatMap = {
      "jpeg" = ".jpg";
      "jpg" = ".jpg";
      "png" = ".png";
    };
    parts = lib.splitString "." (lib.toLower (builtins.baseNameOf inputImage));
    candidate =
      if parts != []
      then lib.last parts
      else "";
  in
    # Match candidate against supported formats or default to JPG
    if candidate != "" && formatMap ? candidate
    then formatMap.${candidate}
    else ".jpg";

  themeJson = builtins.toJSON {
    name = "stylix-base16";
    colors = colorsList;
  };
in
  pkgs.runCommand "recolored-wallpaper" {
    nativeBuildInputs = [pkgs.gowall];
    preferLocalBuild = true;
  } ''
    export HOME=$(pwd) # due to https://github.com/NixOS/nix/issues/670
    # Prepare output directory
    mkdir -p "$out"
    outputFile="$out/wallpaper${extension}"
    defaultLink="$out/default"

    # Process image with Gowall using base16 theme
    echo '${themeJson}' > theme.json
    gowall convert "${inputImage}" -t ./theme.json --output "$outputFile"

    # Create convenient symlink for format-agnostic access
    ln -s "wallpaper${extension}" "$defaultLink"

    # Cleanup temporary config
    rm -rf "$configDir"
  ''
