echo "Disabling A/B"
SET_PROP "product" "ro.product.ab_ota_partitions" --delete

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

# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos990")

echo "Switching to FBE v2"
FBE_V1="fileencryption=ice"
FBE_V2="fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,metadata_encryption=aes-256-xts,keydirectory=/metadata/vold/metadata_encryption"
sed -i "${LINE}s|resgid=5678|resgid=5678,inlinecrypt|g" "$WORK_DIR/vendor/etc/fstab.exynos990" \
    && sed -i "${LINE}s|$FBE_V1|$FBE_V2|g" "$WORK_DIR/vendor/etc/fstab.exynos990"

# Samsung ODE
ENTRIES="
ODE
keydata
keyrefuge
"
for e in $ENTRIES; do
    sed -i "/${e}/d" "$WORK_DIR/vendor/etc/fstab.exynos990"
done
