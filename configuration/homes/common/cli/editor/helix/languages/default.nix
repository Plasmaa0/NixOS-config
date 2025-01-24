{pkgs, ...}: {
  # languages with extra configs
  imports = [
    ./nix.nix
    ./python.nix
    ./latex.nix
    ./typst.nix
    ./yuck.nix
  ];

  # lsp for languages without extra configs
  programs.helix.extraPackages = with pkgs; [
    # bash
    bash-language-server
    # docker
    dockerfile-language-server-nodejs
    docker-compose-language-service

    # markdown
    marksman
    markdown-oxide

    # cpp
    clang-tools

    # other
    yaml-language-server
    lua-language-server
  ];
}
