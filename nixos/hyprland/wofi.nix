{ pkgs, config, ... }:

{
  programs.wofi.enable = true;

  xdg.configFile."wofi/style.css".text = ''
    window { background: unset; }
    flowboxchild { outline-width: 0; }
    #outer-box {
      background-color: #1C1C1E;
      opacity: 0.85;
      border: 1px solid #3A3A3C;
      border-radius: 24px;
      margin: 5px 5px 10px;
      padding: 5px 5px 10px;
    }
    #input {
      background-color: #3A3A3C;
      opacity: 0.85;
      border: none;
      border-radius: 16px;
      color: #BDBDC0;
      margin: 5px;
    }
    #inner-box {
      background-color: #1C1C1E;
      opacity: 0.85;
      border: none;
      border-radius: 16px;
      margin: 5px;
    }
    #scroll {
      border: none;
      margin: 0px;
    }
    #text {
      color: #BDBDC0;
      margin: 5px;
    }
    #text:selected {
      color: #8E8E93;
    }
    #entry { border-radius: 16px; }
    #entry:selected {
      background-color: #3A3A3C;
    }
  '';
}
