echo "Disabling UFFD GC"
SET_PROP "product" "ro.dalvik.vm.enable_uffd_gc" "false"

echo "Disabling encryption"
# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos9820")
sed -i "${LINE}s/,fileencryption=ice//g" "$WORK_DIR/vendor/etc/fstab.exynos9820"

# ODE
sed -i -e "/ODE/d" -e "/keydata/d" -e "/keyrefuge/d" "$WORK_DIR/vendor/etc/fstab.exynos9820"

echo "Enabling updateable APEX images"
SET_PROP "vendor" "ro.apex.updatable" "true"

echo "Setting /data to F2FS"
FROM="noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic"
TO="noatime,nosuid,nodev,discard,usrquota,grpquota,fsync_mode=nobarrier,reserve_root=32768,resgid=5678"
sed -i -e "${LINE}s/ext4/f2fs/g" -e "${LINE}s/$FROM/$TO/g" "$WORK_DIR/vendor/etc/fstab.exynos9820"

echo "Disabling A2DP Offload"
SET_PROP "system" persist.bluetooth.a2dp_offload.disabled "true"

echo "Setting SF flags"
SET_PROP "vendor" "debug.sf.latch_unsignaled" "1"
SET_PROP "vendor" "debug.sf.high_fps_late_app_phase_offset_ns" "0"
SET_PROP "vendor" "debug.sf.high_fps_late_sf_phase_offset_ns" "0"

echo "Disabling HFR"
SET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "false"
SET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "false"

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
