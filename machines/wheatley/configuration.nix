{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./users.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-4e20ad04-f84e-4f9c-ac1d-ef95612eb7a6".device = "/dev/disk/by-uuid/4e20ad04-f84e-4f9c-ac1d-ef95612eb7a6";
  };

  networking = {
    hostName = "wheatley";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Prague";

  nix.settings.trusted-users = ["root" "jacob"];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  security.rtkit.enable = true;

  services = {
    xserver = {
      enable = true;

      # Enable the Gnome Desktop Environment
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    pulseaudio.enable = false;

    # Enable the X11 windowing system
    # Enable CUPS to print documents
    printing.enable = true;

    # Enable sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Additional services
    netdata.enable = true;
  };

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Virtualisation
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnupg
    libgcc
    podman-compose
    shadow-launcher
    vim
  ];

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # GPU drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
