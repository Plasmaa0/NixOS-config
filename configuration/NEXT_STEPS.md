What to do next
1. Update flake lock
nix flake lock --flake /home/plasmaa0/home-manager/configuration/
This will lock the new devshell input.
2. Ensure your age key is in place
The sops config at configuration/modules/secrets/default.nix has:
- sops.age.keyFile = "/var/lib/sops-nix/key.txt"
- sops.age.generateKey = true — generates a key on first boot if missing
Before rebuilding, decrypt your .sops.yaml age key to /var/lib/sops-nix/key.txt so the rebuild can read secrets:
mkdir -p /var/lib/sops-nix
# If you have the age key locally:
cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt

# Or extract just the public key's identity:
age-keygen -y ~/.config/sops/age/keys.txt > /var/lib/sops-nix/key.txt
The generateKey option will create one if missing, but then the encrypted secrets.yaml won't match because it was encrypted with your existing key. So make sure the correct key is there before building.
3. Rekey secrets.yaml with your key (optional but recommended)
If you haven't already, update configuration/modules/secrets/.sops.yaml with your actual age public key and re-encrypt:
sops updatekeys configuration/modules/secrets/secrets.yaml
4. Build
nix flake check --flake /home/plasmaa0/home-manager/configuration/
If that passes:
nix build '.#nixosConfigurations.zep.config.system.build.toplevel' --flake /home/plasmaa0/home-manager/configuration/
