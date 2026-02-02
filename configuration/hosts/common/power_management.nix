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
  systemd.sleep.extraConfig = ''HibernateDelaySec=30min''; # time after when pc will hibernate when using systemctl suspend-then-hibernate
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };
  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      # USB
      USB_AUTOSUSPEND = 1;

      # BATTERY
      START_CHARGE_THRESH_BAT0 = 30;
      STOP_CHARGE_THRESH_BAT0 = 70;
      START_CHARGE_THRESH_BAT1 = 30;
      STOP_CHARGE_THRESH_BAT1 = 70;

      # CPU
      # sysbench cpu run --threads=24
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative"; #"powersave";

      CPU_SCALING_MIN_FREQ_ON_AC = 599000;
      CPU_SCALING_MAX_FREQ_ON_AC = 5157895;
      CPU_SCALING_MIN_FREQ_ON_BAT = 599000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;

      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "passive";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0; # intel only
      CPU_MAX_PERF_ON_AC = 100; # intel only
      CPU_MIN_PERF_ON_BAT = 0; # intel only
      CPU_MAX_PERF_ON_BAT = 60; # intel only

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # GPU
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      AMDGPU_ABM_LEVEL_ON_AC = 0;
      AMDGPU_ABM_LEVEL_ON_BAT = 4;

      # UTIL
      NMI_WATCHDOG = 0;

      # RAM
      MEM_SLEEP_ON_AC = "s2idle";
      MEM_SLEEP_ON_BAT = "deep";

      # DISK
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";

      # PCIe
      RUNTIME_PM_ON_AC = "on"; # may also be "auto"
      RUNTIME_PM_DRIVER_DENYLIST = "";
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };
}
