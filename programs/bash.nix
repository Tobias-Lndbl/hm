{pkgs, config, lib, ...}:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export EDITOR='vim' 

    '';
  };
}
