{
  nixpkgs,
  inputs,
  outputs,
  home-manager,
}: {
  system,
  host,
  homes,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./hosts/${host}
    {
      networking.hostName = host;
      nix.settings.trusted-users = homes;
      users.users =
        (nixpkgs.lib.genAttrs homes (user: {
          isNormalUser = true;
          description = user;
          extraGroups = ["networkmanager" "wheel"];
          password = import ./homes/common/secrets/${user}_password.nix;
        }))
        // {root.hashedPasswordFile = toString ./homes/common/secrets/root_hashed_password;};
      # https://wiki.nixos.org/wiki/Home_Manager#Workaround_with_home_on_tmpfs_and_standalone_installation
      system.activationScripts.profile-init.text = nixpkgs.lib.concatStringsSep "\n" (map
        (user: "ln -sfn /home/${user}/.local/state/nix/profiles/profile /home/${user}/.nix-profile")
        homes);
      home-manager = {
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        users = nixpkgs.lib.genAttrs homes (user: {
          imports = [
            {
              home.username = user;
              home.homeDirectory = "/home/${user}";
            }
            ./homes/${user}
          ];
        });
      };
    }
  ];
  specialArgs = {inherit inputs outputs home-manager;};
}
