{pkgs, config, ...}:

{
  home.packages = with pkgs; [
    whatsapp-for-linux
  ];
}
