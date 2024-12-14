{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "mkshell";
      runtimeInputs = with pkgs; [coreutils eza];
      text = ''
        set +u

        help(){
          echo "Usage: mkshell TEMPLATE"
          echo "Create shell.nix with specified TEMPLATE"
          echo "Arguments:"
          echo "--help display this message"
          echo "--list display available templates"
          exit 0
        }

        list(){
          echo "Available templates:"
          cd ${./.}
          files=$(eza -l --color=always --icons=auto --no-user --no-time --no-permissions ./*.template)
          descriptions=$(cat ./*.template | head -n 1)
          result=$(paste <(echo -e "$files") <(echo -e "$descriptions") | tr '\t' ' ')
          echo -e "$result"
          exit 0
        }

        if [ -z "$1" ]
        then
          echo "Please, pass an argument"
          echo "--help to show help"
          exit 1
        else
          case $1 in
            --help)
              help
              ;;

            --list)
              list
              ;;

            *)
              if [ ! -f "${./.}/$1.template" ]; then
                  echo "Template '$1' not found!"
                  echo "--help to show help"
                  echo "--list to show available templates"
                  exit 1
              else
                cat "${./.}/$1.template" > shell.nix
                echo "Created 'shell.nix' with template '$1'"
              fi
              ;;
          esac
        fi
      '';
    })
  ];
}
