MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

# Set build ID
ROM_STATUS=""
$ROM_IS_OFFICIAL || ROM_STATUS=" UNOFFICIAL"
VALUE="$(GET_PROP "$WORK_DIR/system/system/build.prop" "ro.build.display.id")"
SET_PROP "system" "ro.build.display.id" "ExtremeROM$ROM_STATUS $ROM_CODENAME $ROM_VERSION - $TARGET_CODENAME ($VALUE)"

SET_PROP "system" "ro.extremerom.official" "$ROM_IS_OFFICIAL"
SET_PROP "system" "ro.extremerom.version" "$ROM_VERSION"
SET_PROP "system" "ro.extremerom.codename" "$ROM_CODENAME"

# Disable FRP
SET_PROP "vendor" "ro.frp.pst" ""
SET_PROP "product" "ro.frp.pst" ""

# Set Edge Lighting model
MODEL=$(echo "$TARGET_FIRMWARE" | sed -E 's/^([^/]+)\/.*/\1/')
SET_PROP "system" "ro.factory.model" "$MODEL"

# Fix portrait mode
SET_PROP "system" "ro.build.flavor" "$(GET_PROP "$FW_DIR/${MODEL}_${REGION}/system/system/build.prop" "ro.build.flavor")"

if [[ -f "$FW_DIR/${MODEL}_${REGION}/vendor/lib64/liblivefocus_capture_engine.so" ]]; then
    if grep -q "ro.product.name" "$FW_DIR/${MODEL}_${REGION}/vendor/lib64/liblivefocus_capture_engine.so"; then
        # For devices with this lib in system instead of vendor (e.g. S22 and up)
        # we will need to sed this in system lib after replacing with stock blob
        # in a platform patch.
        if [[ -f "$FW_DIR/${MODEL}_${REGION}/vendor/lib64/libDualCamBokehCapture.camera.samsung.so" ]]; then
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/libDualCamBokehCapture.camera.samsung.so"
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/libDualCamBokehCapture.camera.samsung.so"
        fi
        sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/liblivefocus_capture_engine.so"
        sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/liblivefocus_preview_engine.so"
        sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/liblivefocus_capture_engine.so"
        sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/liblivefocus_preview_engine.so"
        echo -e "\nro.unica.camera u:object_r:build_prop:s0 exact string" >> "$WORK_DIR/system/system/etc/selinux/plat_property_contexts"
        SET_PROP "system" "ro.unica.camera" "$(GET_PROP "$FW_DIR/${MODEL}_${REGION}/system/system/build.prop" "ro.product.system.name")"
    fi
fi

echo -e "\nro.telephony.sim_slots.count      u:object_r:telephony_config_prop:s0 exact int" >> "$WORK_DIR/system/system/etc/selinux/plat_property_contexts"

{
    echo ""
    echo ""
    echo "on property:ro.vendor.multisim.simslotcount=*"
    echo "    setprop ro.telephony.sim_slots.count \${ro.vendor.multisim.simslotcount}"
    echo ""
} >> "$WORK_DIR/vendor/etc/init/init.vendor.rilcommon.rc"

sed -i s/init.svc.vendor.wvkprov_server_hal//g "$WORK_DIR/vendor/etc/selinux/vendor_property_contexts"
