# S24 FE OneUI 7 -> SoundBooster 2000
# a21s -> SoundBooster 1050
LOG "-Replacing SoundBooster"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver2000.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SAG_EQ_ver2000.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsoundboostereq_legacy.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1050.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

LOG "-Adding 32-Bit WFD blobs"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/lib" 0 0 644 "u:object_r:system_lib_file:s0"

LOG "-Adding RIL permission blobs"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-com.sec.app.RilErrorNotifier.xml" 0 0 644 "u:object_r:system_lib_file:s0"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-com.sec.app.RilErrorNotifier.xml" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-com.sec.android.RilServiceModeApp.xml" 0 0 644 "u:object_r:system_lib_file:s0"
