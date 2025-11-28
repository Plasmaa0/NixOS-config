{
  config,
  pkgs,
  lib,
  ...
}: {
  services.autorandr = {
    enable = true;
    profiles = let
      postHook = {"restart-i3" = "${pkgs.i3}/bin/i3-msg restart";};
      notebookMonitorFingerprint = "00ffffffffffff0028892a4200000000001b0104a51d147803de50a3544c99260f505400000001010101010101010101010101010101b798b8a0b0d03e700820080c25c41000001ab798b8a0b0d041720820080c25c41000001a000000fe004a444920202020202020202020000000fe004c504d3133394d3432324120200039";
      huaweiMonitorFingerprint = "00ffffffffffff0022f6226e22f680c02e1f0104b53c28783a0c95ae5243ae260f505421080081008180010101010101010101010101c7f600a0f00049a030203a00548d2100001a000000ff0020202020202020202020202020000000fd00304b2db445000a202020202020000000fc004d617465566965770a20202020013b020320f0450204105f612309070783010000e305e000e60607016a6a01e200ca785070a080a0295030203a00548d2100001a565e00a0a0a0295030203500548d2100001a5898b8a0b0d0397030203a00548d2100001aca9e0050f5002ea008a03a50548d2100001c94d910a0e060459030203a00548d2100001a000000000056";
      zepMonitorFingerprint = "00ffffffffffff004c83ae410000000000210104b5221678030cf1ae523cb9230c505400000001010101010101010101010101010101000000fe0020202020202020202020202020000000fd0c30f0abab710100000000000000000000fe005344430a202020202020202020000000fc0041544e413630444c30342d3020015c70207902002600090400000000005000002200289a2b1185ff094f0007001f003f06af009d0007009a2b1105ff094f0007001f003f067f156d15070081001f731a0000030b30f000a074026002f0000000008de3058000e60605017460022b000c27003cef00002700303b00002e00060045405e405e00000000000000001e90";
      aocMonitorFingerprint = "00ffffffffffff0005e30327ec0100002e210103803c22782ede2bae4e45a4260e4a4bbfef00d1c081803168317c4568457c6168617c565e00a0a0a029503020350055502100001e000000ff00414847333334365a3030343932000000fc005132374733473352332b0a2020000000fd0030901ee63c000a2020202020200105020349f14c10050413031202110160613f230907078301000067030c002000383c67d85dc4017880036d1a000002013090e60000000000e305e301e30f0006e6060701636300e200f954e900a0a0a055503020380055502100001a6fc200a0a0a055503020350055502100001ef03c00d051a0355060883a0055502100001cb4";
    in {
      "home" = {
        fingerprint = {
          eDP-1 = notebookMonitorFingerprint;
          DP-1 = huaweiMonitorFingerprint;
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2560";
            rate = "59.98";
          };
          eDP-1 = {
            enable = true;
            primary = false;
            position = "0x2560";
            mode = "3000x2000";
            rate = "60.00";
          };
        };
        hooks.postswitch = postHook;
      };
      "hotebook_only" = {
        fingerprint = {
          eDP-1 = notebookMonitorFingerprint;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3000x2000";
            rate = "60.00";
          };
        };
        hooks.postswitch = postHook;
      };
      "zep_240" = {
        fingerprint = {
          eDP = zepMonitorFingerprint;
        };
        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1600";
            rate = "240.00";
            dpi = 180;
          };
        };
        hooks.postswitch = postHook;
      };
      "zep_60" = {
        fingerprint = {
          eDP = zepMonitorFingerprint;
        };
        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1600";
            rate = "60.00";
            dpi = 180;
          };
        };
        hooks.postswitch = postHook;
      };
      "zep_home" = {
        fingerprint = {
          eDP = zepMonitorFingerprint;
          HDMI-1-0 = aocMonitorFingerprint;
          DisplayPort-1 = huaweiMonitorFingerprint; # type-c on the left side (near HDMI)
        };
        config = {
          eDP = {
            enable = true;
            primary = false;
            position = "2560x2560";
            mode = "2560x1600";
            rate = "60.00";
            dpi = 180;
          };
          HDMI-1-0 = {
            enable = true;
            primary = false;
            position = "0x1440";
            mode = "2560x1440";
            rate = "59.95";
          };
          DisplayPort-1 = {
            enable = true;
            primary = true;
            position = "2560x0";
            mode = "3840x2560";
            rate = "59.98";
          };
        };
        hooks.postswitch = postHook;
      };
      "zep_home2" = {
        fingerprint = {
          eDP = zepMonitorFingerprint;
          HDMI-1-0 = aocMonitorFingerprint;
          DP-1-0 = huaweiMonitorFingerprint; # type-c on the right side (near HDMI)
        };
        config = {
          eDP = {
            enable = true;
            primary = false;
            position = "2560x2560";
            mode = "2560x1600";
            rate = "60.00";
            dpi = 180;
          };
          HDMI-1-0 = {
            enable = true;
            primary = false;
            position = "0x1440";
            mode = "2560x1440";
            rate = "59.95";
          };
          DP-1-0 = {
            enable = true;
            primary = true;
            position = "2560x0";
            mode = "3840x2560";
            rate = "59.98";
          };
        };
        hooks.postswitch = postHook;
      };
      "zep_home3" = {
        fingerprint = {
          eDP = zepMonitorFingerprint;
          DP-1-0 = huaweiMonitorFingerprint; # type-c on the right side
        };
        config = {
          eDP = {
            enable = true;
            primary = false;
            position = "2560x2560";
            mode = "2560x1600";
            rate = "60.00";
            dpi = 180;
          };
          DP-1-0 = {
            enable = true;
            primary = true;
            position = "2560x0";
            mode = "3840x2560";
            rate = "59.98";
          };
        };
        hooks.postswitch = postHook;
      };
    };
  };
  # disable autorandr systemd service which is created by services.autorandr.enable=true;
  # because it triggers after every resume from sleep with default configuration by home-manager
  # and i think it's rare edge case that monitor configuration has changed during sleep
  # but it breaks lockscreen (putting it beneath all windows) with the i3-reset postswitch hook.
  # this fix will still create autorandr.service but it will be empty and throw errors when trying
  # to do something with it:
  #      Loaded: bad-setting (Reason: Unit autorandr.service has a bad unit file setting.)
  #      Active: inactive (dead)

  # ... systemd[1]: autorandr.service: Service has no ExecStart=, ExecStop=, or SuccessAction=. Refusing.
  systemd.services.autorandr = lib.mkForce {};
  # but the fix above breaks udev rule /etc/udev/rules.d/40-monitor-hotplug.rules which uses systemd:
  # ACTION=="change", SUBSYSTEM=="drm", RUN+="/run/current-system/systemd/bin/systemctl start --no-block autorandr.service"
  #
  # Create our own udev rules that call autorandr directly
  services.udev.extraRules = ''
    # Monitor hotplug - direct autorandr call
    ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --batch --change --default ${config.services.autorandr.defaultTarget}"
  '';
}
