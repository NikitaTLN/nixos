{ config, pkgs, system, inputs, quickshell, ... }:
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
    kitty = "kitty";
    mako = "mako";
    walls = "walls";
    scripts = "scripts";
    colorschemes = "colorschemes";
    walker = "walker";
    hyprshell = "hyprshell";
    eww = "eww";
    niri = "niri";
    fuzzel = "fuzzel";
    swaync = "swaync";
    DankMaterialShell = "DankMaterialShell";
  };
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;  
    vesktop = {
        enable = true;
        useSystemVencord = false;
    };
    dorion.enable = true;
    config = {
        plugins = {
            fakeNitro.enable = true;
        };
    };
  };
  home.username = "w1dget";
  home.homeDirectory = "/home/w1dget";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.file.".zshrc".source = ./zshrc;
  home.file.".tmux.conf".source = ./tmuxconf;
  home.file.".tmux".source = "${config.home.homeDirectory}/nixos/tmux";
  home.file.".themes".source = "${config.home.homeDirectory}/nixos/themes";
  home.file.".icons".source = "${config.home.homeDirectory}/nixos/icons";
  home.packages = with pkgs; [
    gimp
    loupe
    unityhub
    tree
    fastfetch
    eza
    zoxide
    hyprpicker
    gettext
    hyprshot
    hyprlock
    nix-search-tv
    wlogout
    meson
    hyprpaper
    networkmanagerapplet
    rofi
    wofi
    wofi-emoji
    waybar
    bat
    btop
    pavucontrol
    viber
    cava
    obsidian
    localsend
    libnotify
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
