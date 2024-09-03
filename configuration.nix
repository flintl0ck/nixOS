services.xserver = {
    enable = true;
    videosDrivers = ["nvidia"];
    displayManager.gdm = {
        enable = true;
        wayland = true;
    };
};

hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
};

# hyprland
programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;
};
