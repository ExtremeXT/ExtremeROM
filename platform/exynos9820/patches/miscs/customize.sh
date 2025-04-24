echo "Disabling A/B"
SET_PROP "product" "ro.product.ab_ota_partitions" --delete

echo "Disabling UFFD GC"
SET_PROP "product" "ro.dalvik.vm.enable_uffd_gc" "false"

echo "Disabling A2DP Offload"
SET_PROP "system" "persist.bluetooth.a2dp_offload.disabled" "true"

echo "Setting SF flags"
SET_PROP "vendor" "debug.sf.latch_unsignaled" "1"
SET_PROP "vendor" "debug.sf.high_fps_late_app_phase_offset_ns" "0"
SET_PROP "vendor" "debug.sf.high_fps_late_sf_phase_offset_ns" "0"

# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos9820")

echo "Setting /data to F2FS"
OLD_FLAGS="noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic"
NEW_FLAGS="noatime,nosuid,nodev,discard,usrquota,grpquota,fsync_mode=nobarrier,reserve_root=32768,resgid=5678"
sed -i "${LINE}s|ext4|f2fs|g" "$WORK_DIR/vendor/etc/fstab.exynos9820" \
    && sed -i "${LINE}s|$OLD_FLAGS|$NEW_FLAGS|g" "$WORK_DIR/vendor/etc/fstab.exynos9820"

echo "Switching to FBE v2"
FBE_V1="fileencryption=ice"
FBE_V2="fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,metadata_encryption=aes-256-xts,keydirectory=/metadata/vold/metadata_encryption"
sed -i "${LINE}s|resgid=5678|resgid=5678,inlinecrypt|g" "$WORK_DIR/vendor/etc/fstab.exynos9820" \
    && sed -i "${LINE}s|$FBE_V1|$FBE_V2|g" "$WORK_DIR/vendor/etc/fstab.exynos9820"

# Samsung ODE
ENTRIES="
ODE
keydata
keyrefuge
"
for e in $ENTRIES; do
    sed -i "/${e}/d" "$WORK_DIR/vendor/etc/fstab.exynos9820"
done
