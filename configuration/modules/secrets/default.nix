{inputs, ...}: {
  flake.nixosModules.secrets = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops.age.sshKeyPaths = [];
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;

    sops.defaultSopsFile = ./secrets.yaml;

    sops.secrets.github_token = {};
    sops.secrets.plasmaa0_hashed_password = {neededForUsers = true;};
    sops.secrets.root_hashed_password = {neededForUsers = true;};

    users.users.plasmaa0.hashedPasswordFile = config.sops.secrets.plasmaa0_hashed_password.path;
    users.users.root.hashedPasswordFile = config.sops.secrets.root_hashed_password.path;

    system.activationScripts.sops-nix-access-token = lib.mkAfter ''
      token=$(cat ${config.sops.secrets.github_token.path} 2>/dev/null || true)
      if [ -n "$token" ]; then
        ${pkgs.gnused}/bin/sed -i '/^access-tokens/d' /etc/nix/nix.conf
        echo "access-tokens = github.com=$token" >> /etc/nix/nix.conf
      fi
    '';
  };
}
