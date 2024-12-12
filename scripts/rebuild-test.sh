sudo rm /etc/nixos/* -rf
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild test --flake /etc/nixos --show-trace
