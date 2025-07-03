if $SOURCE_HAS_MASS_CAMERA_APP; then
    if ! $TARGET_HAS_MASS_CAMERA_APP; then
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk" 0 0 644 "u:object_r:system_file:s0"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/priv-app/SamsungCamera/oat"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk.prof" 0 0 644 "u:object_r:system_file:s0"
    else
        echo "TARGET_HAS_MASS_CAMERA_APP is set. Ignoring"
    fi
else
    echo "SOURCE_HAS_MASS_CAMERA_APP is not set. Ignoring"
fi
