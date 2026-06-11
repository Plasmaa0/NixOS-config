{...}: {
  services.thermald.enable = true; # cooler control (as i understand this)
  services.upower = {
    enable = true;
    percentageCritical = 3;
    criticalPowerAction = "Hibernate";
  };
  services.xserver = {
    # Set DPMS timeouts to zero (any timeouts managed by xidlehook)
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "1h"; # time after when pc will hibernate when using systemctl suspend-then-hibernate
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };
  powerManagement.powertop.enable = false; # disable auto-tune
  services.tlp = {
    enable = true;
    pd.enable = true;
    # sysbench cpu run --threads=24
    settings = {
      TLP_AUTO_SWITCH = 2;
      TLP_PROFILE_AC = "PRF";
      TLP_PROFILE_BAT = "BAL";
      TLP_PROFILE_DEFAULT = "BAL";

      START_CHARGE_THRESH_BAT0 = 30;
      STOP_CHARGE_THRESH_BAT0 = 70;
      START_CHARGE_THRESH_BAT1 = 30;
      STOP_CHARGE_THRESH_BAT1 = 70;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      PLATFORM_PROFILE_ON_SAV = "low-power";

      CPU_DRIVER_OPMODE_ON_AC = "active"; # EPP
      CPU_DRIVER_OPMODE_ON_BAT = "passive"; # governor controlled
      CPU_DRIVER_OPMODE_ON_SAV = "passive";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
      CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

      CPU_SCALING_MIN_FREQ_ON_AC = 599000;
      CPU_SCALING_MAX_FREQ_ON_AC = 5157895;
      CPU_SCALING_MIN_FREQ_ON_BAT = 599000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;
      CPU_SCALING_MIN_FREQ_ON_SAV = 599000;
      CPU_SCALING_MAX_FREQ_ON_SAV = 1800000;
      CPU_MIN_PERF_ON_AC = 0; # intel only
      CPU_MAX_PERF_ON_AC = 100; # intel only
      CPU_MIN_PERF_ON_BAT = 0; # intel only
      CPU_MAX_PERF_ON_BAT = 80; # intel only
      CPU_MIN_PERF_ON_SAV = 0; # intel only
      CPU_MAX_PERF_ON_SAV = 60; # intel only

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_BOOST_ON_SAV = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1; # intel cpu hwp dynamic boost
      CPU_HWP_DYN_BOOST_ON_BAT = 0; # intel cpu hwp dynamic boost

      RADEON_DPM_PERF_LEVEL_ON_AC = "high";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
      RADEON_DPM_PERF_LEVEL_ON_SAV = "low";

      AMDGPU_ABM_LEVEL_ON_AC = 0;
      AMDGPU_ABM_LEVEL_ON_BAT = 2;
      AMDGPU_ABM_LEVEL_ON_SAV = 4;

      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_DRIVER_DENYLIST = "";

      USB_AUTOSUSPEND = 1;
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      MEM_SLEEP_ON_AC = "deep";
      MEM_SLEEP_ON_BAT = "deep";
      NMI_WATCHDOG = 0;
    };
  };
}
