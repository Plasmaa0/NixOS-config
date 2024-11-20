sudo rm /etc/nixos/* -rf
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild boot --flake /etc/nixos
