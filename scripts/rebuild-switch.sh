sudo rm /etc/nixos/* -rf
alejandra $(fd .nix)
statix check
deadnix
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild switch --flake /etc/nixos --show-trace
