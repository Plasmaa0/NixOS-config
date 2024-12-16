sudo rm /etc/nixos/* -rf
alejandra $(fd .nix)
statix check
deadnix
sudo cp configuration/* /etc/nixos -r
sudo nix-channel --update
sudo nixos-rebuild boot --flake /etc/nixos --upgrade --show-trace
