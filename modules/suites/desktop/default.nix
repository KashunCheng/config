{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.ocf.suites.desktop;
in
{
  options.ocf.suites.desktop = {
    enable = mkBoolOpt false "Enable common desktop configuration.";
  };

  config = lib.mkIf cfg.enable {
    ocf = {
        assets.ocf-images = enabled;
        desktop = {
            kde = enabled;
        };
    };
    
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    environment.systemPackages = with pkgs; [
        # google-chrome
        # libreoffice-qt
        firefox
    ];
  };
}
