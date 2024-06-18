# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-gaming.nixosModules.pipewireLowLatency
      ../../modules/nixos/mounts.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    #substituters = [ "https://ezkea.cachix.org" ];
    #trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    substituters = [ "https://ezkea.cachix.org" "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

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
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    desktopManager.plasma5.enable = true;
    #displayManager.sddm.enable = true;
    #displayManager.sddm.wayland.enable = true;
    displayManager.lightdm.background = "https://safe.reku.me/jPNXwAPptI8t.png";
  };

  services.libinput = {
    touchpad.naturalScrolling = true;
    touchpad.accelProfile = "flat";
    mouse.accelProfile = "flat";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.opentabletdriver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "load-module module-combine-sink";
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.quantum = 128;
      default.clock.min-quantum = 128;
    };
  };

  services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
    context.modules = [
      {
        name = "libpipewire-module-protocol-pulse";
        args = {
          pulse.min.req = "32/48000";
          pulse.default.req = "32/48000";
          pulse.max.req = "32/48000";
          pulse.min.quantum = "32/48000";
          pulse.max.quantum = "32/48000";
        };
      }
    ];
    stream.properties = {
      node.latency = "32/48000";
      resample.quality = 1;
    };
  };

  services.pipewire.lowLatency = {
    enable = true;
    quantum = 128;
    rate = 48000;
  };

  nixpkgs.config.pulseaudio = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rekunan = {
    isNormalUser = true;
    description = "Mang Nilian";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [
      firefox
      kate
      gparted
      libreoffice-qt
      ntfs3g
      vesktop
      tree
      git
      obsidian
      #ungoogled-chromium
      monero-gui
      gimp
      vscodium
      flatpak
      flatpak-builder
      chatterino2
      inputs.nix-gaming.packages.${pkgs.system}.osu-stable
      inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      inputs.nix-gaming.packages.${pkgs.system}.wine-osu
      unzip
      gnome.zenity
      wineWowPackages.waylandFull
      winetricks
      qbittorrent
      premid
      wl-clipboard
      protonvpn-gui
      ffmpeg-full
      zoom-us
      pandoc
      texliveFull
      pulseaudio
      pulseaudioFull
      pipewire
      libGL
      libGLU
      openssl
      openssl_legacy
      openssl_1_1
      imagemagickBig
      meson
      ninja
      obs-studio
      vlc
      jdk21
      libsForQt5.kamoso
      opentabletdriver
      audacity
      prismlauncher
      baobab
      ncdu
      discord
      tetrio-desktop
      ruffle
      nushell
      tailscale
      fusee-interfacee-tk
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged 
    # programs here, NOT in environment.systemPackages
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1d" # Replace this with the package and version you want to allow
    "openssl-1.1.1w"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nginxStable = prev.nginxStable.override { openssl = prev.openssl_1_1; };
    })
  ];
  
  environment.variables = {
    EDITOR = "nvim";
  };

  #virtualisation.waydroid.enable = true;

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "rekunan" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

  services.flatpak.enable = true;

}
