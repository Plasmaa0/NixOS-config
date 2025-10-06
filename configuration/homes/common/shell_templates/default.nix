{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellApplication rec {
      name = "mkenv";
      runtimeInputs = with pkgs; [coreutils eza gnused fzf bat];
      text = ''
        set +u

        help(){
          echo "Usage: mkenv <template> <env-name> [nixpkgs version]"
          echo "Create flake.nix with specified TEMPLATE and with <env-name>"
          echo "Arguments:"
          echo "--help display this message"
          echo "--list display available template previews in fzf"
          exit 0
        }

        list(){
          echo "Available templates:"
          cd ${./.}
          # eza -l --color=always --icons=auto --no-filesize --no-user --no-time --no-permissions ./template_*.nix
          find template_*.nix | fzf --preview "bat --style header --style snip --style changes --style header {} --color=always" --preview-label="Preview"
          exit 0
        }

        case $1 in
          --help)
            help
            ;;

          --list)
            list
            ;;
        esac
        nixversion="${lib.versions.majorMinor lib.version}"
        if [ -n "$3" ]
        then
          nixversion=$3
        fi
        if [ $# -lt 2 ]
        then
          echo "Please, pass 2 arguments."
          echo "Usage: ${name} <template> <env-name> [nixpkgs version]"
          echo "Example: ${name} cpp \"my-cpp-project\" $nixversion"
          echo "--help to show help"
          exit 1
        else
          if [ ! -f "${./.}/template_$1.nix" ]; then
              echo "Template '$1' not found!"
              echo "--help to show help"
              echo "--list to show available templates"
              exit 1
          else
            echo "Nixpkgs version set to $nixversion"
            # cat "${./.}/$1.nix" > flake.nix
            sed -e "s|%ENV_NAME%|$2|g" \
                -e "s|%NIX_VERSION%|$nixversion|g" \
                "${./.}/template_$1.nix" > flake.nix
            echo use flake > .envrc
            direnv allow
            echo "Created 'flake.nix' with template '$1'"
            echo "Created .envrc"
          fi
        fi
      '';
    })
  ];
}
