{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  system.activationScripts.createPersist = "mkdir -p /persist/home";

  programs.fuse.userAllowOther = true;

  users.mutableUsers = false;
  # why is this not part of base NixOS?
  systemd.tmpfiles.rules = ["d /var/lib/systemd/pstore 0755 root root 14d"];
  # as weird as it sounds, I won't use tmpfs for /tmp in case I'll have to put files over 2GB there
  boot.tmp.cleanOnBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    # TODO: Separate into their modules respectively
    directories =
      map (
        x:
          if builtins.isPath x
          then toString x
          else if builtins.isAttrs x && x ? directory && builtins.isPath x.directory
          then x // {directory = toString x.directory;}
          else x
      ) (
        [
          "/etc/nixos"
          "/var/log"
          "/var/lib/bluetooth"
          "/etc/ssh"
          "/root"
          "/nix"
          {
            directory = /var/lib/alsa;
            user = "root";
            group = "root";
            mode = "0777";
          }
          {
            directory = /etc/alsa;
            user = "root";
            group = "root";
            mode = "0777";
          }
          {
            directory = /var/lib/nixos;
            user = "root";
            group = "root";
            mode = "0755";
          }
          {
            directory = /var/lib/systemd;
            user = "root";
            group = "root";
            mode = "0755";
          }
          {
            directory = /var/tmp;
            user = "root";
            group = "root";
            mode = "1777";
          }
          {
            directory = /var/spool;
            user = "root";
            group = "root";
            mode = "0777";
          }
          {
            directory = /tmp;
            user = "root";
            group = "root";
            mode = "1777";
          }
        ]
        # got this huge list from https://github.com/chayleaf/dotfiles/blob/66a8656ec99760bcc80619e6960a643a96bd664d/system/modules/impermanence.nix
        ++ lib.optionals config.networking.wireless.iwd.enable [
          {
            directory = /var/lib/iwd;
            user = "root";
            group = "root";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.powerManagement.powertop.enable [
          /var/cache/powertop
        ]
        ++ lib.optionals (builtins.any (x: x.useDHCP) (builtins.attrValues config.networking.interfaces) || config.networking.useDHCP) [
          {
            directory = /var/db/dhcpcd;
            user = "root";
            group = "root";
            mode = "0755";
          }
          /var/lib/dhcpd
        ]
        ++ lib.optionals config.security.acme.acceptTerms [
          {
            directory = /var/lib/acme;
            user = "acme";
            group = "acme";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.akkoma.enable [
          {
            directory = /var/lib/akkoma;
            user = "akkoma";
            group = "akkoma";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.botamusique.enable [
          {
            directory = /var/lib/private/botamusique;
            user = "root";
            group = "root";
            mode = "0750";
            defaultPerms.mode = "0700";
          }
        ]
        ++ lib.optionals config.programs.ccache.enable [
          {
            directory = config.programs.ccache.cacheDir;
            user = "root";
            group = "nixbld";
            mode = "0770";
          }
          {
            directory = /var/cache/sccache;
            user = "root";
            group = "nixbld";
            mode = "0770";
          }
        ]
        ++ lib.optionals config.services.certspotter.enable [
          {
            directory = /var/lib/certspotter;
            user = "certspotter";
            group = "certspotter";
            mode = "0755";
          }
        ]
        ++ lib.optionals (config.services.coop-fd.enable or false) [
          {
            directory = /var/lib/private/coop-fd;
            mode = "0750";
            defaultPerms.mode = "0700";
          }
        ]
        ++ lib.optionals config.virtualisation.docker.enable [
          {
            directory = /var/lib/docker;
            user = "root";
            group = "root";
            mode = "0710";
          }
        ]
        ++ lib.optionals config.services.dovecot2.enable [
          {
            directory = /var/lib/dhparams;
            user = "root";
            group = "root";
            mode = "0755";
          }
          {
            directory = /var/lib/dovecot;
            user = "root";
            group = "root";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.fail2ban.enable [
          {
            directory = /var/lib/fail2ban;
            user = "root";
            group = "root";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.forgejo.enable [
          {
            directory = /var/lib/forgejo;
            user = "forgejo";
            group = "forgejo";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.gitea.enable [
          {
            directory = /var/lib/gitea;
            user = "gitea";
            group = "gitea";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.grafana.enable [
          {
            directory = /var/lib/grafana;
            user = "grafana";
            group = "grafana";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.heisenbridge.enable [
          {
            directory = /var/lib/heisenbridge;
            user = "heisenbridge";
            group = "heisenbridge";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.hydra.enable [
          {
            directory = /var/lib/hydra;
            user = "hydra";
            group = "hydra";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.jellyfin.enable [
          {
            directory = /var/lib/jellyfin;
            user = "jellyfin";
            group = "jellyfin";
            mode = "0750";
          }
        ]
        ++ lib.optionals config.services.matrix-appservice-discord.enable [
          {
            directory = /var/lib/private/matrix-appservice-discord;
            mode = "0750";
            defaultPerms.mode = "0700";
          }
        ]
        ++ lib.optionals config.services.matrix-synapse.enable [
          {
            directory = /var/lib/matrix-synapse;
            user = "matrix-synapse";
            group = "matrix-synapse";
            mode = "0700";
          }
        ]
        ++ lib.optionals (config.services.maubot.enable or false) [
          {
            directory = /var/lib/maubot;
            user = "maubot";
            group = "maubot";
            mode = "0750";
          }
        ]
        ++ lib.optionals config.services.monero.enable [
          {
            directory = config.services.monero.dataDir;
            user = "monero";
            group = "monero";
            mode = "0750";
          }
        ]
        ++ lib.optionals config.services.mullvad-vpn.enable [
          {
            directory = /etc/mullvad-vpn;
            user = "root";
            group = "root";
            mode = "0700";
          }
          {
            directory = /var/cache/mullvad-vpn;
            user = "root";
            group = "root";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.murmur.enable [
          {
            directory = /var/lib/murmur;
            user = "murmur";
            group = "murmur";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.nextcloud.enable [
          {
            directory = /var/lib/nextcloud;
            user = "nextcloud";
            group = "nextcloud";
            mode = "0750";
          }
        ]
        ++ lib.optionals config.networking.networkmanager.enable [
          {
            directory = /etc/NetworkManager;
            mode = "0700";
          }
          {
            directory = /var/lib/NetworkManager;
            mode = "0755";
          }
          {
            directory = /var/lib/NetworkManager-fortisslvpn;
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.opendkim.enable [
          {
            directory = /var/lib/opendkim;
            user = "opendkim";
            group = "opendkim";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.openldap.enable [
          {
            directory = /var/lib/openldap;
            inherit (config.services.openldap) user group;
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.pleroma.enable [
          {
            directory = /var/lib/pleroma;
            user = "pleroma";
            group = "pleroma";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.services.postfix.enable [
          {
            directory = /var/lib/postfix;
            user = "root";
            group = "root";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.postgresql.enable [
          {
            directory = /var/lib/postgresql;
            user = "postgres";
            group = "postgres";
            mode = "0755";
          }
        ]
        ++ lib.optionals config.services.printing.enable [
          {
            directory = /var/lib/cups;
            user = "root";
            group = "root";
            mode = "0755";
          }
          {
            directory = /var/cache/cups;
            user = "root";
            group = "lp";
            mode = "0770";
          }
        ]
        ++ lib.optionals config.services.prometheus.enable [
          {
            directory = /var/lib/${config.services.prometheus.stateDir};
            user = "prometheus";
            group = "prometheus";
            mode = "0755";
          }
        ]
        ++ lib.optionals (config.services.qbittorrent-nox.enable or false) [
          {
            directory = /var/lib/qbittorrent-nox;
            mode = "0755";
          }
        ]
        ++ lib.optionals config.security.sudo.enable [
          {
            directory = /var/db/sudo/lectured;
            user = "root";
            group = "root";
            mode = "0700";
          }
        ]
        ++ lib.optionals config.virtualisation.libvirtd.enable [
          # { directory = /var/cache/libvirt; user = "root"; group = "root"; mode = "0755"; }
          {
            directory = /var/lib/libvirt;
            user = "root";
            group = "root";
            mode = "0755";
          }
        ]
      );
    files = map toString [
      # hardware-related
      /etc/adjtime
      # needed at least for /var/log
      /etc/machine-id
      /var/swapfile
    ];
  };
}
