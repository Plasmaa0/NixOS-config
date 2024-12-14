sudo rm /etc/nixos/* -rf
alejandra -q $(fd .nix)
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild boot --flake /etc/nixos $1
