{ config, pkgs, system, inputs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  system = "x86_64-linux";
  configs = {
    hypr = "hypr";
    omp = "omp";
    nvim = "nvim";
    fastfetch = "fastfetch";
    ghostty = "ghostty";
    wofi = "wofi";
    rofi = "rofi";
    waybar = "waybar";
    wlogout = "wlogout";
    mako = "mako";
    walls = "walls";
    scripts = "scripts";
    quickshell = "quickshell";
    walker = "walker";
  };
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];


  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      bar.status = {
        showBattery = false;
      };
      paths.wallpaperDir = "~/.config/walls/";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };


  services.walker.enable = true;
  programs.zen-browser.enable = true;
  programs.quickshell.enable = true;
  home.username = "w1dget";
  home.homeDirectory = "/home/w1dget";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.file.".zshrc".source = ./zshrc;
  home.file.".tmux.conf".source = ./tmuxconf;
  home.file.".tmux".source = "${config.home.homeDirectory}/nixos/tmux";
  home.file.".themes".source = "${config.home.homeDirectory}/nixos/themes";
  home.file.".icons".source = "${config.home.homeDirectory}/nixos/icons";
  home.file."~/Documents/Obsidian Vault".source = "${config.home.homeDirectory}/nixos/ObsidianVault";
  home.packages = with pkgs; [
    loupe
    unityhub
    tree
    fastfetch
    eza
    zoxide
    hyprpicker
    hyprshot
    hyprlock
    wlogout
    hyprpaper
    networkmanagerapplet
    rofi
    wofi
    wofi-emoji
    waybar
    bat
    btop
    discord
    pavucontrol
    viber
    cava
    obsidian
    localsend
    inputs.hyprlauncher.packages.${pkgs.system}.default
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })
  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
