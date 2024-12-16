sudo rm /etc/nixos/* -rf
alejandra $(fd .nix)
statix check
deadnix
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild boot --flake /etc/nixos $1
