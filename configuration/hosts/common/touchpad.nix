{...}: {
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    # scroll by holding middle mouse button
    mouse = {
      scrollMethod = "button";
      scrollButton = 2;
    };
  };
}
