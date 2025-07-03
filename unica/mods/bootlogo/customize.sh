if [[ $TARGET_SINGLE_SYSTEM_IMAGE == "essi" || $TARGET_SINGLE_SYSTEM_IMAGE == "essi_64" ]]; then
    echo "Exynos device detected! Adding custom up_param!"
    if $TARGET_HAS_QHD_DISPLAY; then
        cp -a "$SRC_DIR/unica/mods/bootlogo/up_param_1440p.bin" "$WORK_DIR/up_param.bin"
    else
        cp -a "$SRC_DIR/unica/mods/bootlogo/up_param_1080p.bin" "$WORK_DIR/up_param.bin"
    fi
else
    echo "Non-Exynos device detected, skipping custom up_param!"
fi
