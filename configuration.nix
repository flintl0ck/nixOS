{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./modules/nvidia.nix
      ./modules/disable-gpu.nix
      ./modules/system-packages.nix
      # Include Home Manager when configured. add "inputs" to line 1 when enabled.
      # inputs.home-manager.nixosModules.default
    ];

  # Enable NixOS auto-update
  system.autoUpgrade.enable  = true;
  system.autoUpgrade.allowReboot  = true;

#  main-user.enable = true;
#  main-user.userName = "chris";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Enable usage flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.variables.EDITOR = "nano";
  
  # Setting allowed users to reduce sudo use
  nix.settings.allowed-users = [
    "@wheel"
    "chris"
  ];
  nix.settings.trusted-users = [
    "@wheel"
    "chris"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
  };
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.windowManager.hypr.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable Bluetooth
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    description = "chris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vim
      neovim
      firefox
    #  thunderbird
    ];
  };

   # Define home-manager user configurations
   # home-manager = {
     # extraSpecialArgs = { inherit inputs; };
     # users = {
         # "chris" = import ./home.nix;
     # };
   # };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "chris";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Perform garbage collection weekly to maintain low disk usage
#  nix.gc = {
#    automatic = true;
#    dates = "weekly";
#    options = "--delete-older-than 1w";
#  };

#  nix.settings.auto-optimise-store = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # Enable Cachix
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  
  # Enable hyprland
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
    hyprlock = {
      enable = true;
    };
  };


# environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enabling policy owner for PolKit
   security.polkit.enable = true;
  # polkitPolicyOwners = [ "chris" ];
  
  # List services that you want to enable:
   services.hypridle.enable = true;

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
