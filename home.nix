{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    omp = "omp";
    nvim = "nvim";
    ghostty = "ghostty";
    wofi = "wofi";
    rofi = "rofi";
    waybar = "waybar";
    wlogout = "wlogout";
    mako = "mako";
    walls = "walls";
    scripts = "scripts";
  };
in
{

  home.username = "w1dget";
  home.homeDirectory = "/home/w1dget";
  home.stateVersion = "25.05";
  home.file.".zshrc".source = ./zshrc;
  home.file.".tmux.conf".source = ./tmuxconf;
  home.file.".tmux".source = "${config.home.homeDirectory}/nixos/tmux";
  home.file.".themes".source = "${config.home.homeDirectory}/nixos/themes";
  home.file.".icons".source = "${config.home.homeDirectory}/nixos/icons";
  home.packages = with pkgs; [
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
    inputs.zen-browser.packages."${system}".specific
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        (nix-search-tv.overrideAttrs {
          env.GOEXPERIMENT = "jsonv2";
        })
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
