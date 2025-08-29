{ pkgs }:

pkgs.writeShellScriptBin "my-awesome-script" ''
  
  ACTIVEWORKSPACE='"id": 4,'

  ACTIVEWORKSPACE= hyprctl activeworkspace -j | grep '.id'
  if [ACTIVEWORKSPACE -eq '"id": 4,']
  then 
    echo "yayy"
  else
    echo "nooo"
  fi
''
