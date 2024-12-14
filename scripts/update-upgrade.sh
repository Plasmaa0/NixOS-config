sudo rm /etc/nixos/* -rf
alejandra -q $(fd .nix)
sudo cp configuration/* /etc/nixos -r
sudo nix-channel --update
sudo nixos-rebuild boot --flake /etc/nixos --upgrade --show-trace
