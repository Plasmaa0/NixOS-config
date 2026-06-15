{...}: {
  flake.nixosModules.ananicy = {
    pkgs,
    lib,
    ...
  }: {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      settings = {
        loglevel = lib.mkForce "info";
        log_applied_rule = true;
      };
    };

    # https://github.com/CachyOS/ananicy-rules/issues/207
    systemd.services.ananicy-cpp = {
      serviceConfig.Delegate = true;
    };
  };
}
