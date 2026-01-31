{config, lib, ...}:

{

  options.appearance = {
      hasBattery = lib.mkOption {
      description = "Used to display battery information in status bar";
      type = lib.types.bool;
      default = false;
    };
  };
}
