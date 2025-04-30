# S25 Ultra OneUI 7 -> SoundBooster 2060
# S21 Series -> SoundBooster 1050
echo "Replacing SoundBooster"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver2060.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1070.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

echo "Replacing GameDriver"
DELETE_FROM_WORK_DIR "system" "system/priv-app/GameDriver-SM8750"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/GameDriver-EX2100/GameDriver-EX2100.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/DevGPUDriver-EX2100/DevGPUDriver-EX2100.apk" 0 0 644 "u:object_r:system_file:s0"

echo "Replacing Hotword"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx6_WIDEBAND_LARGE"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentYGoogleEx6_WIDEBAND_LARGE"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "priv-app/HotwordEnrollmentOKGoogleEx3CORTEXM4/HotwordEnrollmentOKGoogleEx3CORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "priv-app/HotwordEnrollmentXGoogleEx3CORTEXM4/HotwordEnrollmentXGoogleEx3CORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"

echo "Downgrading VaultKeeper JNI"
ADD_TO_WORK_DIR "dm3qxxx" "system" "system/lib64/libvkjni.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "dm3qxxx" "system" "system/lib64/libvkmanager.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "dm3qxxx" "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper@2.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper-V1-ndk.so"

echo "Replacing USB init files"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/init/hw/init.usb.configfs.rc" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/init/hw/init.usb.rc" 0 0 644 "u:object_r:system_file:s0"

echo "Add 32-Bit WFD blobs"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/lib" 0 0 644 "u:object_r:system_lib_file:s0"
