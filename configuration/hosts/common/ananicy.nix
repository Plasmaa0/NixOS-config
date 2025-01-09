{pkgs, ...}: {
  services.ananicy = let
    acpp = pkgs.ananicy-cpp;
  in {
    enable = true;
    package = acpp;
    rulesProvider = acpp;
    # settings = {
    #   apply_nice = false;
    # };
  };
}
