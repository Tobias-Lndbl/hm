{config, lib, ...}:

let

  cfg = config.appearance;

in with lib; {

  options.appearance = {
      hasBattery = mkOption {
      description = "Used to display battery information in status bar";
      type = types.bool;
      default = false;
    };
  };
}
