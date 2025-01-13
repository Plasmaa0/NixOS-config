{
  config,
  pkgs,
  ...
}: {
  services.copyq.enable = true;
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/copyq"];
  # FIXME this script now works only with images
  home.packages = [
    (pkgs.writeShellApplication {
      name = "clip-file";
      runtimeInputs = with pkgs; [copyq xdg-utils];
      text = ''
        set +u
        file=$1
        if [ -z "$file" ]
        then
          echo "Please, pass filename"
          exit 1
        else
          mimetype=$(xdg-mime query filetype "$file")
          echo Detected mime-type "$mimetype"
          copyq write "$mimetype" - < "$file" && copyq select 0 && echo "Copied!" || echo "Failure!"
        fi
      '';
    })
  ];
}
