{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./packages.nix
    ];

  nixpkgs.config.allowUnfree = true;

  services.tailscale.enable = true;
  services.ratbagd.enable = true;
  i18n.defaultLocale = "ru_RU.UTF-8";


  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    limine = {
      enable = true;
      secureBoot.enable = true;

      extraConfig = ''
          timeout = 30
          term_palette: 24273a;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5
          term_palette_bright: 5b6078;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5
          term_background: 24273a
          term_foreground: cad3f5
          term_background_bright: 5b6078
          term_foreground_bright: cad3f5
      '';
      extraEntries = ''
          /Windows
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
          comment: Boot into Windows
          /Arch Linux (linux-zen)
          protocol: linux
          path: boot():../vmlinuz-linux-zen
          cmdline: root=PARTUUID=b7e7d29e-0938-4842-a54c-d9f5f58f1b89 zswap.enabled=0 rw rootfstype=btrfs
          module_path: boot():../initramfs-linux-zen.img
          comment: Boot into Arch Rice (zen kernel)
          /Arch Linux (linux)
            protocol: linux
            path: boot():../vmlinuz-linux
            cmdline: root=PARTUUID=b7e7d29e-0938-4842-a54c-d9f5f58f1b89 zswap.enabled=0 rw rootfstype=btrfs
            module_path: boot():../initramfs-linux.img
            comment: Boot into Arch Rice
      '';
    };
  };

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  services.openssh.enable = true;
  programs.niri.enable = true;

# bash prompt: PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='\[\e[38;5;45m\]\w\[\e[0m\] \[\e[38;5;196m\]${PS1_CMD1}\n\[\e[38;5;48m\]❯\[\e[0m\] '

  programs.virt-manager.enable = true;
  programs.nix-ld.enable = true;
  users.groups.libvirtd.members = ["w1dget"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "vitreous";
  services.displayManager.sddm.extraPackages = with pkgs; [ kdePackages.qtmultimedia ];
  services.displayManager.sddm.settings = {
      General = {
          GreeterEnvironment = "QML_XHR_ALLOW_FILE_READ=1";
      };
      Theme = {
          ThemeDir = "/usr/share/sddm/themes/";
      };
  };

  systemd.user.services."sddm-weather" = {
      enable = true;
      description = "Update weather string for SDDM";
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = "/home/w1dget/.config/systemd/user/env.env";
        ExecStart = ''/usr/local/bin/update-sddm-weather'';
      };
  };
  systemd.user.timers."sddm-weather" = {
      enable = true;
      wantedBy = [ "timers.target" ];
      description = "Refresh SDDM weather every 10 minutes";
      timerConfig = {
          OnBootSec = "20s";
          OnUnitActiveSec = "10min";
          AccuracySec="30s";
          Persistent="true";
      };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  users.users.w1dget = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  users.defaultUserShell = pkgs.zsh;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.mwProCapture.enable = true;
  services.flatpak.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  programs.appimage = {
      enable = true;
      binfmt = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  system.stateVersion = "25.05";
}
