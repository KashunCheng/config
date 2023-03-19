{ lib, config, ... }:
with lib;
let
  cfg = config.ocf.assets.ocf-images;
in
{
  options.ocf.assets.ocf-images = {
    enable = mkBoolOpt false "Load ocf image resources.";
  };

  config = lib.mkIf cfg.enable {
    environment.etc = {
      "ocf/icons".source = ./assets/icons;
      "ocf/images".source = ./assets/images;
    };
  };
}
