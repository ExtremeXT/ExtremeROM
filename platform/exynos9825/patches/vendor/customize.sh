echo "Updating Vendor HALs..."
BLOBS_LIST="
bin/hw/android.hardware.health@2.1-service-samsung
bin/hw/vendor.samsung.hardware.snap@1.2-service
bin/hw/vendor.samsung.hardware.sysinput@1.2-service
bin/hw/vendor.samsung.hardware.vibrator@2.2-service
etc/audio_policy_configuration_sec.xml
etc/init/android.hardware.health@2.1-service-samsung.rc
etc/init/vendor.samsung.hardware.snap-1.2-lazy-service.rc
etc/init/vendor.samsung.hardware.sysinput@1.2-service.rc
etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc
etc/vintf/manifest/android.hardware.health@2.1-samsung.xml
lib/android.hardware.health@2.1.so
lib/hw/android.hardware.graphics.mapper@2.0-impl.so
lib/hw/vendor.samsung.hardware.snap@1.2-impl.so
lib/vendor.samsung.hardware.snap@1.0.so
lib/vendor.samsung.hardware.snap@1.1.so
lib/vendor.samsung.hardware.snap@1.2.so
lib64/android.hardware.health@2.1.so
lib64/android.hardware.vibrator@1.0.so
lib64/android.hardware.vibrator@1.1.so
lib64/android.hardware.vibrator@1.2.so
lib64/android.hardware.vibrator@1.3.so
lib64/hw/android.hardware.graphics.mapper@2.0-impl.so
lib64/hw/vendor.samsung.hardware.snap@1.2-impl.so
lib64/vendor.samsung.hardware.snap@1.0.so
lib64/vendor.samsung.hardware.snap@1.1.so
lib64/vendor.samsung.hardware.snap@1.2.so
lib64/vendor.samsung.hardware.vibrator@2.0.so
lib64/vendor.samsung.hardware.vibrator@2.1.so
lib64/vendor.samsung.hardware.vibrator@2.2.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "vendor" "$blob"
done

# Fix SNAP AIDL SELinux rule
sed -i "s/(allow snap_hidl hal_snap_service (service_manager (find)))/(allow snap_hidl hal_snap_service (service_manager (add find)))/g" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"

# Fix JSQZ node permission
echo "/dev/jsqz                 0660   mediacodec     camera" >> $WORK_DIR/vendor/ueventd.rc

# S21 Light HAL
ADD_TO_WORK_DIR "p3sxxx" "vendor" "bin/hw/vendor.samsung.hardware.light-service"
ADD_TO_WORK_DIR "p3sxxx" "vendor" "lib64/android.hardware.light-V1-ndk_platform.so"
ADD_TO_WORK_DIR "p3sxxx" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"
