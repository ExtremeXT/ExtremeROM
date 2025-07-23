BUILD_KERNEL()
{
    local PARENT="$(pwd)"
    cd "$KERNEL_TMP_DIR/floppy"

    EVAL "./do_build.sh ku"

    cd "$PARENT"
}

BUILD_DTBO_IMAGE()
{
    local PARENT="$(pwd)"
    cd "$KERNEL_TMP_DIR/floppy"

    EVAL "mkdtboimg cfg_create "kernel_build/images/dtbo.img" "$SRC_DIR/platform/exynos1280/patches/floppy/configs/$TARGET_CODENAME.cfg" -d "out/arch/arm64/boot/dts/exynos/samsung/$TARGET_CODENAME""

    cd "$PARENT"
}

SAFE_PULL_CHANGES()
{
    set -eo pipefail

    local PARENT="$(pwd)"
    cd "$KERNEL_TMP_DIR/floppy"

    git fetch origin

    LOCAL="$(git rev-parse @)"
    REMOTE="$(git rev-parse origin)"
    BASE="$(git merge-base @ origin)"

    # Now we have three cases that we need to take care of.
    if [ "$LOCAL" = "$REMOTE" ]; then
        LOG "- Local branch is up-to-date with remote"
    elif [ "$LOCAL" = "$BASE" ]; then
        LOG "- Fast-forward possible. Pulling"
        git pull --ff-only
    elif [ "$REMOTE" = "$BASE" ]; then
        LOG "- Local branch is ahead of remote. Not doing anything"
    else
	      cd "$PARENT"
        LOGE "Remote history has diverged (possible force-push)"
    fi

    cd "$PARENT"
}

REPLACE_KERNEL_IMAGES()
{
    local KERNEL_TMP_DIR="$KERNEL_TMP_DIR-s5e8825"
    local FLOPPY_REPO="https://github.com/FlopKernel-Series/flop_s5e8825_kernel"

    [ ! -d "$KERNEL_TMP_DIR" ] && mkdir -p "$KERNEL_TMP_DIR"

    if [ -d "$KERNEL_TMP_DIR/floppy/.git" ]; then
        LOG "- Existing git repo found, trying to pull latest changes"
        if ! SAFE_PULL_CHANGES; then
		        LOGE "Could not pull latest Kernel changes. If you hold local changes, please rebase to the new base. If not, cleaning the kernel_tmp_dir should suffice."
	      fi
    else
        LOG "- Cloning FloppyKernel"
        [ -d "$KERNEL_TMP_DIR/floppy" ] && rm -rf "$KERNEL_TMP_DIR/floppy"
        EVAL "git clone "$FLOPPY_REPO" --single-branch "$KERNEL_TMP_DIR/floppy""
    fi

    LOG "- Running the kernel build script"
    BUILD_KERNEL

    LOG "- Building dtbo image"
    BUILD_DTBO_IMAGE

    # Move the files to the work dir
    KERNEL_IMAGES=(dtbo.img boot_oneui.img vendor_boot.img)
    for b in "${KERNEL_IMAGES[@]}"; do
        [ -f "$WORK_DIR/kernel/$b" ] && rm -f "$WORK_DIR/kernel/$b"
        cp -fa "$KERNEL_TMP_DIR/floppy/kernel_build/images/$b" "$WORK_DIR/kernel"
    done
    mv -f "$WORK_DIR/kernel/boot_oneui.img" "$WORK_DIR/kernel/boot.img"
}

ADD_KERNELSU_NEXT_MANAGER()
{
    local KERNELSU_MANAGER_APK="https://github.com/KernelSU-Next/KernelSU-Next/releases/download/v1.0.9/KernelSU_Next_v1.0.9_12797-release.apk"
    # https://github.com/tiann/KernelSU/issues/886
    local APK_PATH="system/preload/KernelSU-Next/com.rifsxd.ksunext-mesa==/base.apk"

    LOG "- Adding KernelSU-Next.apk to preload apps"
    mkdir -p "$WORK_DIR/system/$(dirname "$APK_PATH")"
    curl -L -s -o "$WORK_DIR/system/$APK_PATH" -z "$WORK_DIR/system/$APK_PATH" "$KERNELSU_MANAGER_APK"

    sed -i "/system\/preload/d" "$WORK_DIR/configs/fs_config-system" \
        && sed -i "/system\/preload/d" "$WORK_DIR/configs/file_context-system"
    while read -r i; do
        FILE="$(echo -n "$i"| sed "s.$WORK_DIR/system/..")"
        [ -d "$i" ] && echo "$FILE 0 0 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
        [ -f "$i" ] && echo "$FILE 0 0 644 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
        FILE="$(echo -n "$FILE" | sed 's/\./\\./g')"
        echo "/$FILE u:object_r:system_file:s0" >> "$WORK_DIR/configs/file_context-system"
    done <<< "$(find "$WORK_DIR/system/system/preload")"

    rm -f "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
    while read -r i; do
        FILE="$(echo "$i" | sed "s.$WORK_DIR/system..")"
        echo "$FILE" >> "$WORK_DIR/system/system/etc/vpl_apks_count_list.txt"
    done <<< "$(find "$WORK_DIR/system/system/preload" -name "*.apk" | sort)"
}

ADD_KERNELSU_NEXT_MANAGER &
REPLACE_KERNEL_IMAGES

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

rm -rf "$TMP_DIR"

