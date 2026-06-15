{...}: {
  flake.homeModules.cli = {config, ...}: {
    home.persistence."/persist".directories = [".cache/fastfetch"];
    home.file."${config.xdg.configHome}/fastfetch/config.jsonc".text = ''
      {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "logo": {
              "type": "kitty",
              "source": "${./NixOS.png}"
          },
          "display": {
              "separator": " "
          },
          "modules": [
              {
                  "key": "╭───────────╮",
                  "type": "custom"
              },
              {
                  "key": "│ {#31} user    {#keys}│",
                  "type": "title",
                  "format": "{user-name}"
              },
              {
                  "key": "│ {#32}󰇅 hname   {#keys}│",
                  "type": "title",
                  "format": "{host-name}"
              },
              {
                  "key": "│ {#33}󰅐 uptime  {#keys}│",
                  "type": "uptime"
              },
              {
                  "key": "│ {#34}{icon} distro  {#keys}│",
                  "type": "os"
              },
              {
                  "key": "│ {#35} kernel  {#keys}│",
                  "type": "kernel"
              },
              {
                  "key": "│ {#36}󰇄 desktop {#keys}│",
                  "type": "de"
              },
              {
                  "key": "│ {#31} term    {#keys}│",
                  "type": "terminal"
              },
              {
                  "key": "│ {#32} shell   {#keys}│",
                  "type": "shell"
              },
              {
                  "key": "│ {#33}󰍛 cpu     {#keys}│",
                  "type": "cpu",
                  "showPeCoreCount": true
              },
              {
                  "key": "│ {#34}󰉉 disk    {#keys}│",
                  "type": "disk",
                  "folders": "/persist"
              },
              {
                  "key": "│ {#35}🏠 home   {#keys}│",
                  "type": "disk",
                  "folders": "/persist/home"
              },
              {
                  "key": "│ {#36} memory  {#keys}│",
                  "type": "memory"
              },
              {
                  "key": "│ {#37}󰩟 network {#keys}│",
                  "type": "localip",
                  "format": "{ipv4} ({ifname})"
              },
              {
                  "key": "├───────────┤",
                  "type": "custom"
              },
              {
                  "key": "│ {#39} colors  {#keys}│",
                  "type": "colors",
                  "symbol": "circle"
              },
              {
                  "key": "╰───────────╯",
                  "type": "custom"
              }
          ]
      }
    '';
  };
}
