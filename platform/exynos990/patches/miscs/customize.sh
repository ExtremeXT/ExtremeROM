echo "Disabling UFFD GC"
SET_PROP "product" "ro.dalvik.vm.enable_uffd_gc" "false"

echo "Setting casefold props"
SET_PROP "vendor" "external_storage.projid.enabled" "1"
SET_PROP "vendor" "external_storage.casefold.enabled" "1"
SET_PROP "vendor" "external_storage.sdcardfs.enabled" "0"
SET_PROP "vendor" "persist.sys.fuse.passthrough.enable" "true"

echo "Setting SF flags"
SET_PROP "vendor" "debug.sf.latch_unsignaled" "1"
SET_PROP "vendor" "debug.sf.high_fps_late_app_phase_offset_ns" "0"
SET_PROP "vendor" "debug.sf.high_fps_late_sf_phase_offset_ns" "0"

echo "Setting Adaptive HFR flags"
if [[ "$MODEL" != "c1s" && "$MODEL" != "c2s" ]]; then
    SET_PROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    SET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "300"
    SET_PROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "600"
    SET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"
fi

echo "Disabling encryption"
# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos990")
sed -i "${LINE}s/,fileencryption=ice//g" "$WORK_DIR/vendor/etc/fstab.exynos990"

# ODE
sed -i -e "/ODE/d" -e "/keydata/d" -e "/keyrefuge/d" "$WORK_DIR/vendor/etc/fstab.exynos990"

# For some reason we are missing 2 permissions here: android.hardware.security.model.compatible and android.software.controls
# First one is related to encryption and second one to SmartThings Device Control
echo "Patching vendor permissions"
sed -i '$d' "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo "    <!-- Indicate support for the Android security model per the CDD. -->" >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo "    <feature name=\"android.hardware.security.model.compatible\"/>" >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo "    <!--  Feature to specify if the device supports controls.  -->" >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo "    <feature name=\"android.software.controls\"/>" >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
echo "</permissions>" >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
