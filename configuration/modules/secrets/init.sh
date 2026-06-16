#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

puts() { printf "\n=== %s ===\n" "$*"; }

# find sops / age-keygen commands (prefer ones already on PATH, fallback to nix run)
find_cmd() {
    local name=$1
    local nixpkg=$2
    if command -v "$name" &>/dev/null; then
        echo "$name"
    else
        echo "$(nix build nixpkgs#"$nixpkg" --print-out-paths --no-link)"/bin/"$name"
        # echo "nix run nixpkgs#$nixpkg -- $name"
    fi
}
AGE_KEYGEN=$(find_cmd age-keygen age)
SOPS=$(find_cmd sops sops)

# -- 1. Admin key ------------------------------------------
puts "1. Admin key"

ADMIN_KEY="$HOME/.config/sops/age/keys.txt"
if [ ! -f "$ADMIN_KEY" ]; then
    echo "No admin key found at $ADMIN_KEY"
    mkdir -p "$(dirname "$ADMIN_KEY")"
    $AGE_KEYGEN -o "$ADMIN_KEY"
    echo "Generated admin key at $ADMIN_KEY"
fi
ADMIN_PUB=$($AGE_KEYGEN -y "$ADMIN_KEY")
echo "Admin public key: $ADMIN_PUB"

# -- 2. Machine key ----------------------------------------
puts "2. Machine key"

MACHINE_KEY="/persist/var/lib/sops-nix/key.txt"
if [ ! -f "$MACHINE_KEY" ] || [ ! -s "$MACHINE_KEY" ]; then
    echo "Generating machine key at $MACHINE_KEY ..."
    sudo mkdir -p "$(dirname "$MACHINE_KEY")"
    sudo $AGE_KEYGEN -o "$MACHINE_KEY"
fi
MACHINE_PUB=$(sudo $AGE_KEYGEN -y "$MACHINE_KEY")
echo "Machine public key: $MACHINE_PUB"

# -- 3. Write .sops.yaml -----------------------------------
puts "3. Writing .sops.yaml"

cat > .sops.yaml <<EOF
keys:
  - &admin $ADMIN_PUB
  - &machine $MACHINE_PUB
creation_rules:
  - path_regex: secrets\.yaml$
    key_groups:
      - age:
          - *admin
          - *machine
EOF
echo "Written .sops.yaml"

# -- 4. Create & encrypt secrets.yaml ----------------------
puts "4. Creating encrypted secrets.yaml"

# mkpasswd -m sha-512  <- use this to generate password hashes
cat > /tmp/secrets.yaml <<'EOF'
github_token: github.com=ghp_.....
plasmaa0_hashed_password: $6$......
root_hashed_password: $6$......
EOF

$SOPS --encrypt /tmp/secrets.yaml > secrets.yaml
shred -zu -n 10 -f /tmp/secrets.yaml
echo "Written secrets.yaml"

# -- Done ---------------------------------------------------
puts "Done!"

echo "Next steps:"
echo "  1. Edit secrets:  cd $SCRIPT_DIR && $SOPS secrets.yaml"
echo "  2. Put real values:"
echo "       github_token             - your GitHub personal access token"
echo "       plasmaa0_hashed_password - run: mkpasswd -m sha-512"
echo "       root_hashed_password     - run: mkpasswd -m sha-512"
echo "  3. Rebuild:  just rebuild-switch"
