{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "elio";
  version = "v1.12.0";

  src = fetchFromGitHub {
    owner = "elio-fm";
    repo = "elio";
    tag = version;
    hash = "sha256-FT5F3L8IgbX6vPjEd+TSudoyIZe4TX7no0FF9C75aaU=";
  };

  cargoHash = "sha256-gnUPukVYevg6JpPIVqDt/9LMtb3FmC8NNgJH6AU8fBE=";

  doCheck = false;

  postInstall = ''
    install -Dm0644 packaging/linux/elio.desktop -t $out/share/applications
    for size in 48 128 256 512; do
      install -Dm0644 packaging/linux/icons/hicolor/''${size}x''${size}/apps/elio.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/elio.png
    done
  '';

  meta = with lib; {
    description = "Snappy, batteries-included terminal file manager with rich previews, inline images, bulk actions, and trash support";
    homepage = "https://github.com/elio-fm/elio";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "elio";
    platforms = platforms.linux;
  };
}
