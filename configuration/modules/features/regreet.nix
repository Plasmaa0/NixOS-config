{...}: {
  flake.nixosModules.regreet = {
    pkgs,
    self,
    ...
  }: {
    programs.regreet.enable = true;
    # services.xserver = {
    #   enable = true;
    #   displayManager.session = [
    #     {
    #       manage = "window";
    #       name = "home-manager";
    #       start = ''
    #         ${pkgs.runtimeShell} $HOME/.hm-xsession &
    #         waitPID=$!
    #       '';
    #     }
    #   ];
    # };
    # home-manager.sharedModules = [
    #   self.homeModules.xsession-script-path
    # ];
  };
  # flake.homeModules.xsession-script-path = {...}: {
  #   xsession.scriptPath = ".hm-xsession";
  # };
}
