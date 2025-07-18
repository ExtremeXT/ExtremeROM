MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if [ -d "$FW_DIR/${MODEL}_${REGION}/system/system/media/audio/pensounds" ]; then
    echo "Adding SPen stack"
    ADD_TO_WORK_DIR "dm3qxxx" "system" "system/app/AirGlance"
    ADD_TO_WORK_DIR "dm3qxxx" "system" "system/app/LiveDrawing"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/permissions/com.samsung.android.spensdk.framework-v1.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/public.libraries-smps.samsung.txt"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/sysconfig/airviewdictionaryservice.xml"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/framework/com.samsung.android.spensdk.framework-v1.jar"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/libsmpsft.smps.samsung.so"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/media/audio/pensounds"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/priv-app/AirCommand"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/priv-app/AirReadingGlass"
    ADD_TO_WORK_DIR "pa3qxxx" "system" "system/priv-app/SmartEye"
else
    echo "SPen support detected in target device. Ignoring."
fi
