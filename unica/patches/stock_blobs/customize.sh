SOURCE_FIRMWARE_PATH="$FW_DIR/$(echo -n "$SOURCE_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

echo "Replacing saiv blobs with stock"
DELETE_FROM_WORK_DIR "system" "system/saiv"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/saiv" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/saiv/face"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/saiv/face" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/saiv/textrecognition"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/saiv/textrecognition" 0 0 755 "u:object_r:system_file:s0"

echo "Replacing cameradata blobs with stock"
DELETE_FROM_WORK_DIR "system" "system/cameradata"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/cameradata" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/cameradata/preloadfilters"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/cameradata/preloadfilters" 0 0 755 "u:object_r:system_file:s0"
DELETE_FROM_WORK_DIR "system" "system/cameradata/myfilter"
ADD_TO_WORK_DIR "$SOURCE_FIRMWARE_PATH" "system" "system/cameradata/myfilter" 0 0 755 "u:object_r:system_file:s0"

if [ -f "$TARGET_FIRMWARE_PATH/system/system/usr/share/alsa/alsa.conf" ]; then
    echo "Add stock alsa.conf"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/usr/share/alsa/alsa.conf" 0 0 644 "u:object_r:system_file:s0"
fi

echo "Replacing gamebooster props with stock"
SET_PROP "product" "ro.gfx.driver.0" "$(GET_PROP "$WORK_DIR/vendor/build.prop" "ro.gfx.driver.0")"
SET_PROP "product" "ro.gfx.driver.1" "$(GET_PROP "$WORK_DIR/vendor/build.prop" "ro.gfx.driver.1")"

if [[ "$SOURCE_PRODUCT_FIRST_API_LEVEL" -gt 33 ]]; then
    echo "Downgrading VaultKeeper JNI"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/libvkjni.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/libvkmanager.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper@2.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
    DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.vaultkeeper-V1-ndk.so"

    echo "Downgrading ENGMODE JNI"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/lib.engmode.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/lib.engmodejni.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "r11sxxx" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
    DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.engmode-V1-ndk.so"
fi
