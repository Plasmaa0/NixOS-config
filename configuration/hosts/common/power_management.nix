{...}: {
  services.thermald.enable = true; # cooler control (as i understand this)
  services.upower = {
    enable = true;
    percentageCritical = 3;
    criticalPowerAction = "Hibernate";
  };
  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # USB
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;
      USB_EXCLUDE_WWAN = 1;

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
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";

      CPU_SCALING_MIN_FREQ_ON_AC = 599000;
      CPU_SCALING_MAX_FREQ_ON_AC = 5156000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 599000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 2000000;

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
      RUNTIME_PM_ON_AC = "auto"; # default in "on"
    };
  };
}
