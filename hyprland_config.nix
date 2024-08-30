{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Hyprland on boot
  services.xserver = {
    enable = true;
    layout = "us"; # Set your keyboard layout
    videoDrivers = [ "modesetting" ]; # Ensure you have the correct video drivers
    windowManager.hyprland.enable = true;
    displayManager.sddm.enable = true; # Use SDDM as the display manager
  };

  # Enable Pipewire for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.your_username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ]; # Adjust groups as necessary
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Set your locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable networking
  networking.networkmanager.enable = true;
