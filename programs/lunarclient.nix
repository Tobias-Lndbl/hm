{pkgs, ...}:
let
  # Wraps the launcher so the game gets hardware OpenGL on NVIDIA + Wayland.
  # Both variables are only read by NVIDIA's driver, so this is a no-op on
  # Mesa/AMD/Intel hosts. --set-default keeps a value already in the env.
  lunar-client = pkgs.symlinkJoin {
    name = "lunarclient";
    paths = [ pkgs.lunar-client ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Lunar's FHS sandbox replaces /etc, so NVIDIA's EGL can't find its
      # Wayland platform (egl-wayland) and Minecraft falls back to llvmpipe.
      # /run is bind-mounted, and the same config lives there.
      # Threaded optimizations break SDL3 window creation on NVIDIA Wayland
      # (EGL_BAD_DISPLAY in eglChooseConfig), and Lunar opts into them.
      wrapProgram $out/bin/lunarclient \
        --set-default __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS /run/opengl-driver/share/egl/egl_external_platform.d \
        --set-default __GL_THREADED_OPTIMIZATIONS 0
    '';
  };
in
{
  home.packages = [
    lunar-client
  ];
}
