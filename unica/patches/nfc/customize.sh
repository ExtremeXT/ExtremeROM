if [[ "$TARGET_NFC_CHIP_VENDOR" == "NXP" && "$SOURCE_NFC_CHIP_VENDOR" == "SLSI" ]]; then
    BLOBS_LIST="
    system/lib64/libnfc_sec_jni.so
    system/lib64/libnfc-nci_flags.so
    system/lib64/libnfc-sec.so
    system/lib64/libstatslog_nfc.so
    system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    system/etc/libnfc-nci.conf
    system/lib64/libnfc_nxpsn_jni.so
    system/lib64/vendor.samsung.hardware.nfc_aidl-V1-ndk.so
    system/lib64/vendor.samsung.hardware.nfc@2.0.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "pa3qxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done

    ln -sf "/system/lib64/libnfc_nxpsn_jni.so" "$WORK_DIR/system/system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so"
    SET_METADATA "system" "system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so" 0 0 644 "u:object_r:system_file:s0"
else
    echo "NFC chip is not NXP, ignoring..."
fi
