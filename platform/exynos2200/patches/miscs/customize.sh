# [
APPLY_PATCH()
{
    local PATCH
    local OUT

    DECODE_APK "$1"

    cd "$APKTOOL_DIR/$1"
    PATCH="$SRC_DIR/platform/exynos2200/patches/miscs/$2"
    OUT="$(patch -p1 -s -t -N --dry-run < "$PATCH")" \
        || echo "$OUT" | grep -q "Skipping patch" || false
    patch -p1 -s -t -N --no-backup-if-mismatch < "$PATCH" &> /dev/null || true
    cd - &> /dev/null
}

# Encryption
echo "Disabling encryption"
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.s5e9925")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2//g" "$WORK_DIR/vendor/etc/fstab.s5e9925"

# 60Hz refresh rate for S22/S22+
if [[ "$TARGET_CODENAME" = "r0s" || "$TARGET_CODENAME" = "g0s" ]]; then
    echo "Applying refresh rate patch"

    DECODE_APK "system/framework/framework.jar"

    APPLY_PATCH "system/framework/framework.jar" "hfr/0001-Fix-60hz-refresh-rate.patch"
fi

echo "Setting stock Bluetooth profiles"
SET_PROP "product" "bluetooth.profile.asha.central.enabled" "true"
SET_PROP "product" "bluetooth.profile.a2dp.source.enabled" "true"
SET_PROP "product" "bluetooth.profile.avrcp.target.enabled" "true"
SET_PROP "product" "bluetooth.profile.bap.broadcast.assist.enabled" "false"
SET_PROP "product" "bluetooth.profile.bap.broadcast.source.enabled" "false"
SET_PROP "product" "bluetooth.profile.bap.unicast.client.enabled" "false"
SET_PROP "product" "bluetooth.profile.bas.client.enabled" "false"
SET_PROP "product" "bluetooth.profile.csip.set_coordinator.enabled" "false"
SET_PROP "product" "bluetooth.profile.gatt.enabled" "true"
SET_PROP "product" "bluetooth.profile.hap.client.enabled" "false"
SET_PROP "product" "bluetooth.profile.hfp.ag.enabled" "true"
SET_PROP "product" "bluetooth.profile.hid.device.enabled" "true"
SET_PROP "product" "bluetooth.profile.hid.host.enabled" "true"
SET_PROP "product" "bluetooth.profile.map.server.enabled" "true"
SET_PROP "product" "bluetooth.profile.mcp.server.enabled" "false"
SET_PROP "product" "bluetooth.profile.opp.enabled" "false"
SET_PROP "product" "bluetooth.profile.pan.nap.enabled" "true"
SET_PROP "product" "bluetooth.profile.pan.panu.enabled" "true"
SET_PROP "product" "bluetooth.profile.pbap.server.enabled" "true"
SET_PROP "product" "bluetooth.profile.sap.server.enabled" "true"
SET_PROP "product" "bluetooth.profile.ccp.server.enabled" "false"
SET_PROP "product" "bluetooth.profile.vcp.controller.enabled" "false"

if [[ "$TARGET_CODENAME" == "r0s" || "$TARGET_CODENAME" == "r11s" ]]; then
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/apex/com.android.btservices.apex" 0 0 644 "u:object_r:system_file:s0"
else
    ADD_TO_WORK_DIR "b0sxxx" "system" "system/apex/com.android.btservices.apex" 0 0 644 "u:object_r:system_file:s0"
fi
