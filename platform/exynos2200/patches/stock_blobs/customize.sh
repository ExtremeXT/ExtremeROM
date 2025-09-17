# S25 FE -> SoundBooster 2000
# S23 FE -> Soundbooster 2080
# S22 Series -> SoundBooster 1100
if [[ "$TARGET_CODENAME" != "r11s" ]]; then
    LOG_STEP_IN "- Replacing SoundBooster"
    DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver2080.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SAG_EQ_ver2080.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/libsoundboostereq_legacy.so"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1100.so" 0 0 644 "u:object_r:system_lib_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
    LOG_STEP_OUT

    LOG_STEP_IN "- Replacing GameDriver"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/GameDriver-EX2200/GameDriver-EX2200.apk" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/DevGPUDriver-EX2200/DevGPUDriver-EX2200.apk" 0 0 644 "u:object_r:system_file:s0"
    LOG_STEP_OUT
fi

if [[ "$TARGET_CODENAME" = "b0s" ]]; then
    LOG_STEP_IN "- Adding SPen SEC Feature"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.spen_usp_level70.xml" 0 0 644 "u:object_r:system_file:s0"
    LOG_STEP_OUT
fi

LOG_STEP_IN "- Adding stock NFC Case features"
if [[ "$TARGET_CODENAME" != "r11s" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/LedCoverService/LedCoverService.apk" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.ledbackcover.xml" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.nfcledcover.xml" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-com.sec.android.cover.ledcover.xml" 0 0 644 "u:object_r:system_file:s0"
fi 
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.sview.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.nfc_authentication_cover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.flip.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.clearcameraviewcover.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT
