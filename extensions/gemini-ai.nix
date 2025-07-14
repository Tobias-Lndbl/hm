{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.gemini-ai
  ];
}
