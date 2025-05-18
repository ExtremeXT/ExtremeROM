echo "Setting casefold props"
SET_PROP "vendor" "external_storage.projid.enabled" "1"
SET_PROP "vendor" "external_storage.casefold.enabled" "1"
SET_PROP "vendor" "external_storage.sdcardfs.enabled" "0"
SET_PROP "vendor" "persist.sys.fuse.passthrough.enable" "true"

echo "Enable Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "true"
SET_PROP "vendor" "debug.hwui.use_hint_manager" "true"

echo "Disabling encryption"
# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos2100")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2//g" "$WORK_DIR/vendor/etc/fstab.exynos2100"

# ODE
sed -i -e "/ODE/d" -e "/keydata/d" -e "/keyrefuge/d" "$WORK_DIR/vendor/etc/fstab.exynos2100"
