sudo rm /etc/nixos/* -rf
alejandra -q $(fd .nix)
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild switch --flake /etc/nixos --show-trace
