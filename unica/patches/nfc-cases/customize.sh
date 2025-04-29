#!/usr/bin/env bash

SOURCE_FIRMWARE_PATH="$FW_DIR/$(echo -n "$SOURCE_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

if [ -f "$TARGET_FIRMWARE_PATH/system/system/etc/permissions/com.sec.feature.cover.xml" ]; then
    ADD_TO_WORK_DIR "p3sxxx" "system" "system/priv-app/LedCoverService/LedCoverService.apk"
    ADD_TO_WORK_DIR "p3sxxx" "system" "system/etc/permissions/privapp-permissions-com.sec.android.cover.ledcover.xml"

    find "$TARGET_FIRMWARE_PATH/system/system/etc/permissions" -type f -name "com.sec.feature.cover.*" -printf "%f\n" | while read -r file; do
        if [ "$file" == "com.sec.feature.cover.nfcledcover.xml" ]; then
            echo "Support for NFC LED Cover is highly experimental and may not work as expected."
            sleep 2
        fi
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE_PATH" "system" "system/etc/permissions/$file" 0 0 644 "u:object_r:system_file:s0"
    done
fi
