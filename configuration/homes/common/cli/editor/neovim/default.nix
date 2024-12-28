{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    plugins.lualine.enable = true;
    # plugins.lsp.servers = {
    # };
  };
}
