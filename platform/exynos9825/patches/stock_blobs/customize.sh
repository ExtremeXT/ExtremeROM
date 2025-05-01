# S24+ OneUI 7 -> SoundBooster 2000
# N10 Series -> SoundBooster 1050
echo "Replacing SoundBooster"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver2000.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1050.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

echo "Replacing GameDriver"
DELETE_FROM_WORK_DIR "system" "system/priv-app/GameDriver-EX2400"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/GameDriver-EX9825/GameDriver-EX9825.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/DevGPUDriver-EX9825/DevGPUDriver-EX9825.apk" 0 0 644 "u:object_r:system_file:s0"

MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

echo "Replacing Hotword"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx6_WIDEBAND_LARGE"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentYGoogleEx6_WIDEBAND_LARGE"
cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/system/system/priv-app/HotwordEnrollmentOKGoogleExCORTEXM4" "$WORK_DIR/product/priv-app"
cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/system/system/priv-app/HotwordEnrollmentXGoogleExCORTEXM4" "$WORK_DIR/product/priv-app"

SET_METADATA "product" "priv-app/HotwordEnrollmentOKGoogleExCORTEXM4" 0 0 755 "u:object_r:system_file:s0"
SET_METADATA "product" "priv-app/HotwordEnrollmentOKGoogleExCORTEXM4/HotwordEnrollmentOKGoogleExCORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"
SET_METADATA "product" "priv-app/HotwordEnrollmentOKGoogleExCORTEXM4/HotwordEnrollmentOKGoogleExCORTEXM4.apk.prof" 0 0 644 "u:object_r:system_file:s0"
SET_METADATA "product" "priv-app/HotwordEnrollmentXGoogleExCORTEXM4" 0 0 755 "u:object_r:system_file:s0"
SET_METADATA "product" "priv-app/HotwordEnrollmentXGoogleExCORTEXM4/HotwordEnrollmentXGoogleExCORTEXM4.apk" 0 0 644 "u:object_r:system_file:s0"
SET_METADATA "product" "priv-app/HotwordEnrollmentXGoogleExCORTEXM4/HotwordEnrollmentXGoogleExCORTEXM4.apk.prof" 0 0 644 "u:object_r:system_file:s0"

echo "Adding 32-Bit WFD blobs"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/lib" 0 0 644 "u:object_r:system_lib_file:s0"

echo "Adding stock NFC Case features"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.sview.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.nfc_authentication_cover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.clearcover.xml" 0 0 644 "u:object_r:system_file:s0"

if [[ "$TARGET_CODENAME" != "beyondx" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.flip.xml" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.ledbackcover.xml" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.nfcledcover.xml" 0 0 644 "u:object_r:system_file:s0"
fi

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/LedBackCoverAppBeyond/LedBackCoverAppBeyond.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.app.ledbackcover.xml" 0 0 644 "u:object_r:system_file:s0"
