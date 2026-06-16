# 1. Generate your age key (or use an existing one)
# Creates ~/.config/sops/age/keys.txt if it doesn't exist
```
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```
# Get your public key
```
ag-keygen -y ~/.config/sops/age/keys.txt
```

# 2. Update .sops.yaml with your public key
# Edit: configuration/modules/secrets/.sops.yaml
# Replace key with your actual public key

# 3. Create the encrypted secrets.yaml
```
cd configuration/modules/secrets
cat > secrets.yaml << 'EOF'
github_token: ghp_your_github_token_here
plasmaa0_hashed_password: $y$j9T$your_hashed_password_hash
root_hashed_password: $y$j9T$your_root_hashed_password_hash
EOF
```
```
sops --encrypt secrets.yaml > secrets.enc.yaml
mv secrets.enc.yaml secrets.yaml
rm secrets.yaml  # the plaintext one
```
Alternatively, use sops to edit in-place directly:
```
sops configuration/modules/secrets/secrets.yaml
```

Key configuration details
- Key file path: /var/lib/sops-nix/key.txt — generated automatically on first boot via sops.age.generateKey = true. If you want to use a specific key, put it there manually.
- Passwords are hashed (from mkpasswd -m sha-512), not plaintext. neededForUsers = true ensures the file is available before the user activation step.
- GitHub token is injected via system.activationScripts (runs after sops decrypts) because nix.settings.access-tokens is evaluated at build time but sops decrypts at activation time — can't use builtins.readFile on the sops path directly.
