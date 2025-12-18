{pkgs,...}:

{
  home.packages = with pkgs; [
    python313Packages.dbus-python
  ];
}
