KERNELSU_MANAGER_APK="https://github.com/KernelSU-Next/KernelSU-Next/releases/download/v1.0.9/KernelSU_Next_v1.0.9_12797-release.apk"
# https://github.com/tiann/KernelSU/issues/886
APK_PATH="system/preload/KernelSU-Next/com.rifsxd.ksunext-mesa==/base.apk"

LOG "- Adding KernelSU-Next.apk to preload apps"
mkdir -p "$WORK_DIR/system/$(dirname "$APK_PATH")"
DOWNLOAD_FILE "$KERNELSU_MANAGER_APK" "$WORK_DIR/system/$APK_PATH"

sed -i "/system\/preload/d" "$WORK_DIR/configs/fs_config-system"
sed -i "/system\/preload/d" "$WORK_DIR/configs/file_context-system"
while read -r i; do
    FILE="$(echo -n "$i"| sed "s.$WORK_DIR/system/..")"
    [[ -d "$i" ]] && echo "$FILE 0 0 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
    [[ -f "$i" ]] && echo "$FILE 0 0 644 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
    FILE="$(echo -n "$FILE" | sed 's/\./\\./g')"
    echo "/$FILE u:object_r:system_file:s0" >> "$WORK_DIR/configs/file_context-system"
done <<< "$(find "$WORK_DIR/system/system/preload")"

rm -f "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
while read -r i; do
    FILE="$(echo "$i" | sed "s.$WORK_DIR/system..")"
    echo "$FILE" >> "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
done <<< "$(find "$WORK_DIR/system/system/preload" -name "*.apk" | sort)"
