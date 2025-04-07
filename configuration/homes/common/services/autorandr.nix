{pkgs, ...}: {
  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;
    profiles = let
      postHook = "${pkgs.i3}/bin/i3-msg restart";
      notebookMonitorFingerprint = "00ffffffffffff0028892a4200000000001b0104a51d147803de50a3544c99260f505400000001010101010101010101010101010101b798b8a0b0d03e700820080c25c41000001ab798b8a0b0d041720820080c25c41000001a000000fe004a444920202020202020202020000000fe004c504d3133394d3432324120200039";
      huaweiMonitorFingerprint = "00ffffffffffff0022f6226e22f680c02e1f0104b53c28783a0c95ae5243ae260f505421080081008180010101010101010101010101c7f600a0f00049a030203a00548d2100001a000000ff0020202020202020202020202020000000fd00304b2db445000a202020202020000000fc004d617465566965770a20202020013b020320f0450204105f612309070783010000e305e000e60607016a6a01e200ca785070a080a0295030203a00548d2100001a565e00a0a0a0295030203500548d2100001a5898b8a0b0d0397030203a00548d2100001aca9e0050f5002ea008a03a50548d2100001c94d910a0e060459030203a00548d2100001a000000000056";
      zepMonitorFingerprint = "00ffffffffffff004c83ae410000000000210104b5221678030cf1ae523cb9230c505400000001010101010101010101010101010101000000fe0020202020202020202020202020000000fd0c30f0abab710100000000000000000000fe005344430a202020202020202020000000fc0041544e413630444c30342d3020015c70207902002600090400000000005000002200289a2b1185ff094f0007001f003f06af009d0007009a2b1105ff094f0007001f003f067f156d15070081001f731a0000030b30f000a074026002f0000000008de3058000e60605017460022b000c27003cef00002700303b00002e00060045405e405e00000000000000001e90";
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
          };
        };
        hooks.postswitch = postHook;
      };
    };
  };
}
