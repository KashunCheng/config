{ lib, config, pkgs,... }:
with lib;
let
  cfg = config.ocf.desktop.kde;
in
{
  options.ocf.desktop.kde = {
    enable = mkBoolOpt false "Enable KDE(Plasma5).";
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      SNOWFALL_EXAMPLE = "enabled";
    };
    
    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
    services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "breeze";
    services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name = "breeze";
    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme.name = "breeze_cursors";
    services.xserver.displayManager.lightdm.greeters.gtk.indicators = ["~host" "~spacer" "~clock" "~spacer" "~layout" "~language" "~session" "~ally" "~power"];

    # TODO: Can we use config.ocf.assets.base_directory || "login.png" instead?
    services.xserver.displayManager.lightdm.background = "/etc/ocf/images/login.png";

    environment.etc = {
      skel.source = ./skel;
    };

    environment.etc = {
      foo = {
        text = "bar";
        mode = "0777";
      };
    };

    ocf.suites.auth.pamServices = ["lightdm"];
  };
}
