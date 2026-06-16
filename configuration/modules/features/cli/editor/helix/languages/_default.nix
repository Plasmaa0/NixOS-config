{pkgs, ...}: {
  # languages with extra configs
  imports = [
    ./_nix.nix
    ./_python.nix
    ./_latex.nix
    ./_typst.nix
    ./_yuck.nix
    ./_cpp.nix
  ];

  # lsp for languages without extra configs
  programs.helix.extraPackages = with pkgs; [
    # bash
    bash-language-server
    # docker
    dockerfile-language-server
    docker-compose-language-service

    # markdown
    marksman
    markdown-oxide

    # other
    yaml-language-server
    lua-language-server
    superhtml
    asm-lsp
  ];
}
