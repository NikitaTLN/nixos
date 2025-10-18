{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  services.tailscale.enable = true;

  boot.loader = {
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
      '';
    };
  };

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";

  programs.virt-manager.enable = true;
  programs.virtualbox.enable = true;
  users.groups.libvirtd.members = ["w1dget"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  services.displayManager.ly.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  users.users.w1dget = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    ];
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

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    ghostty
    fd
    flatpak
    efibootmgr
    gh
    neovim
    gcc
    ripgrep
    feh
    fuse
    fzf
    htop
    lazygit
    nautilus
    nodejs
    oh-my-posh
    nwg-look
    sassc
    slurp
    spotify
    steam
    tmux
    uwsm
    xdg-utils
    appimage-run
    python3
    go
    cargo
    rustc
    pkg-config
    vial
    qmk
    qmk-udev-rules
    qmk_hid
    via
    jq
    ungoogled-chromium
    sbctl
    cliphist
    wl-clipboard-rs
    rpi-imager
  ];

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
