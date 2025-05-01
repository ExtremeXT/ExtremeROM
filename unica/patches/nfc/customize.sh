if [ "$SOURCE_NFC_CHIP_VENDOR" != "$TARGET_NFC_CHIP_VENDOR" ]; then
    if [ "$TARGET_NFC_CHIP_VENDOR" = "SLSI" ]; then
        echo "Replacing NFC blobs with SLSI"

        DELETE_FROM_WORK_DIR "system" "system/lib64/libnfc_nxpsn_jni.so"
        DELETE_FROM_WORK_DIR "system" "system/priv-app/NfcNci/lib/arm64/libnfc_nxpsn_jni.so"

        ADD_TO_WORK_DIR "e2sxxx" "system" "system/etc/libnfc-nci.conf" 0 0 644 "u:object_r:system_file:s0"

        BLOBS_LIST="
        system/lib64/libnfc_sec_jni.so
        system/lib64/libnfc-nci_flags.so
        system/lib64/libnfc-sec.so
        system/lib64/libstatslog_nfc.so
        "
        for blob in $BLOBS_LIST
        do
            ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
        done

        # Create libnfc_sec_jni symlink
        ln -sf "/system/lib64/libnfc_sec_jni.so" "$WORK_DIR/system/system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so"
        SET_METADATA "system" "system/priv-app/NfcNci/lib/arm64/libnfc_sec_jni.so" 0 0 644 "u:object_r:system_file:s0"
    else
        echo "NXP NFC found. Ignoring."
    fi
else
    echo "NFC chip vendor unchanged. No action taken."
fi

