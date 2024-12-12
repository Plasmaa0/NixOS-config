{...}:{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.plasmaa0 = {
    isNormalUser = true;
    description = "andrey";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
