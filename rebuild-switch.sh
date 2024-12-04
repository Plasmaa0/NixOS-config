sudo rm /etc/nixos/* -rf
sudo cp configuration/* /etc/nixos -r
sudo nixos-rebuild switch --flake /etc/nixos $1
