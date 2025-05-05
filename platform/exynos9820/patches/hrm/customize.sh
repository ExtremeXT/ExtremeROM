if [[ "$TARGET_CODENAME" != "beyond0lte" ]]; then
    echo "Add stock HRM blobs"
    BLOBS_LIST="
    system/etc/permissions/privapp-permissions-com.sec.android.service.health.xml
    system/etc/permissions/android.hardware.sensor.heartrate.xml
    system/etc/permissions/com.sec.feature.spo2.xml
    system/lib64/libhr.so
    system/priv-app/HealthServicePAR
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob"
    done
else
    echo "Detected beyond0! Skipping HRM..."
fi
