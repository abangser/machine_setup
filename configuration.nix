{ config, pkgs, lib, ... }:

with lib;
with builtins;

let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;

in
{

  imports = [
    ./hardware-configuration.nix

    "${home-manager}/nixos"
  ];

  config = {

    system.stateVersion = "19.09";

    sound.enable = true;
    hardware.pulseaudio.enable = true;

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 5;
      };

      cleanTmpDir = true;
    };

    users.users.abby = {
      isNormalUser = true;
      extraGroups = [
        "audio"
        "networkmanager"
        "sudo"
        "wheel"
      ]; # Enable ‘sudo’ for the user.
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "uk";
    };

    time.timeZone = "Europe/London";
    
    i18n = {
      #consoleFont = "Lat2-Terminus16";
      #consoleKeyMap = "uk";
      defaultLocale = "en_GB.UTF-8";
    };

    services.xserver = {
      enable = true;
      layout = "gb";

      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };

    networking = {
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      lsof
      vim
      wget
    ];

    home-manager.users.abby = {
      nixpkgs.config.allowUnfree = true;

      programs = {
        firefox.enable = true;
      };
    };

  };

}
