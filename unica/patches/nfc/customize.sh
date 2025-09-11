if [[ "$TARGET_NFC_CHIP_VENDOR" == "SLSI" && "$SOURCE_NFC_CHIP_VENDOR" == "NXP" ]]; then
    BLOBS_LIST="
    system/lib64/libnfc_nci_jni.so
    system/lib64/libnfc_prop_extn.so
    system/lib64/libnfc_vendor_extn.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    system/lib64/libnfc_sec_jni.so
    system/etc/libnfc-nci.conf
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done
else
    LOG "- NFC chip is not SLSI. Ignoring."
fi
