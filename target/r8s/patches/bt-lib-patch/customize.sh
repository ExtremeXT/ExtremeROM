if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.bt.apex"

    [ -d "$TMP_DIR" ] && EVAL "rm -rf \"$TMP_DIR\""
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.bt.apex\" \"apex_payload.img\" -d \"$TMP_DIR\""

    if ! sudo -n -v &> /dev/null; then
        LOG "\033[0;33m! Asking user for sudo password\033[0m"
        if ! sudo -v 2> /dev/null; then
            ABORT "Root permissions are required to unpack APEX image"
        fi
    fi

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cat \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" > \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""

    EVAL "sudo umount \"$TMP_DIR/tmp_out\""
    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"

    LOG_STEP_OUT
fi

# https://github.com/duhansysl/Bluetooth-Library-Patcher/blob/67e598ad142ed296b487a7a4585927c993d4f35d/hexpatcher.sh#L43
HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
    "289777394805003736008052" "289777392a00001436008052"