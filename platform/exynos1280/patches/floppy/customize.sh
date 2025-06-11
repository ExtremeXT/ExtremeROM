BUILD_KERNEL()
{
    local PARENT="$(pwd)"
    local DEVICE=($TARGET_CODENAME)
    [ "$TARGET_CODENAME" = "a53x" ] && local DEVICE=(A536B A536E)
    cd "$KERNEL_TMP_DIR/floppy"

    if [ "$TARGET_CODENAME" = "a53x" ]; then
        sed -i "s/AP_AUDIO_SLSI/AP_AUDIO_SLSI-eur/g" "$KERNEL_TMP_DIR/floppy/arch/arm64/boot/dts/exynos/samsung/a53x/a53x_eur"*
        sed -i "s/APDV_AUDIO_SLSI/APDV_AUDIO_SLSI-eur/g" "$KERNEL_TMP_DIR/floppy/arch/arm64/boot/dts/exynos/samsung/a53x/a53x_eur"*
        sed -i "s/AP_AUDIO_SLSI/AP_AUDIO_SLSI-cis/g" "$KERNEL_TMP_DIR/floppy/arch/arm64/boot/dts/exynos/samsung/a53x/a53x_cis"*
        sed -i "s/APDV_AUDIO_SLSI/APDV_AUDIO_SLSI-cis/g" "$KERNEL_TMP_DIR/floppy/arch/arm64/boot/dts/exynos/samsung/a53x/a53x_cis"*
    fi

    ./do_build.sh k

    [ "$TARGET_CODENAME" = "a53x" ] && git restore "$KERNEL_TMP_DIR/floppy/arch/arm64/boot/dts/exynos/samsung/a53x"

    for d in "${DEVICE[@]}"; do
        echo "- Building dtbo image for $d"
        "$SRC_DIR/platform/exynos1280/patches/floppy/bin/mkdtimg" cfg_create \
            "kernel_build/dtbo-$d.img" \
            "$SRC_DIR/platform/exynos1280/patches/floppy/configs/$d.cfg" \
            -d "out/arch/arm64/boot/dts/exynos/samsung/$TARGET_CODENAME"
    done

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
        echo "Local branch is up-to-date with remote."
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "Fast-forward possible. Pulling..."
        git pull --ff-only
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "Local branch is ahead of remote. Not doing anything."
    else
        echo "ERR: Remote history has diverged (possible force-push)."
	    cd "$PARENT"
	    return 1
    fi

    cd "$PARENT"
}

REPLACE_KERNEL_IMAGES()
{
    local KERNEL_TMP_DIR="$KERNEL_TMP_DIR-$TARGET_PLATFORM"
    local FLOPPY_REPO="https://github.com/FlopKernel-Series/flop_s5e8825_kernel"

    [ ! -d "$KERNEL_TMP_DIR" ] && mkdir -p "$KERNEL_TMP_DIR"

    if [ -d "$KERNEL_TMP_DIR/floppy/.git" ]; then
        echo "Existing git repo found, trying to pull latest changes."
        if ! SAFE_PULL_CHANGES; then
		    echo "ERR: Could not pull latest Kernel changes."
		    echo "If you hold local changes, please rebase to the new base."
		    echo "If not, cleaning the kernel_tmp_dir should suffice."
		    return 1
	    fi
    else
        echo "Cloning FloppyKernel"
        [ -d "$KERNEL_TMP_DIR/floppy" ] && rm -rf "$KERNEL_TMP_DIR/floppy"
        git clone "$FLOPPY_REPO" --single-branch "$KERNEL_TMP_DIR/floppy"
    fi

    echo "- Running the kernel build script."
    BUILD_KERNEL

    # Move the files to the work dir
    KERNEL_IMAGES=(boot vendor_boot)
    for b in "${KERNEL_IMAGES[@]}"; do
        [ -f "$WORK_DIR/kernel/$b*.img" ] && rm -f "$WORK_DIR/kernel/$b*.img"
        [ -f "$KERNEL_TMP_DIR/floppy/kernel_build/$b*.img" ] && mv -f "$KERNEL_TMP_DIR/floppy/kernel_build/$b*.img" "$WORK_DIR/kernel"
    done

    if [ "$TARGET_CODENAME" != "a53x" ]; then
        mv "$WORK_DIR/kernel/dtbo-$TARGET_CODENAME.img" "$WORK_DIR/kernel/dtbo.img"
    else
        [ -f "$WORK_DIR/kernel/dtbo"* ] && rm -f "$WORK_DIR/kernel/dtbo"*
        mv "$KERNEL_TMP_DIR/floppy/kernel_build/dtbo-A536B.img" "$WORK_DIR/kernel/dtbo-eur.img"
        mv "$KERNEL_TMP_DIR/floppy/kernel_build/dtbo-A536E.img" "$WORK_DIR/kernel/dtbo-cis.img"
    fi
}

ADD_KERNELSU_NEXT_MANAGER()
{
    local KERNELSU_MANAGER_APK="https://github.com/KernelSU-Next/KernelSU-Next/releases/download/v1.0.7/KernelSU_Next_v1.0.7_12602-release.apk"
    # https://github.com/tiann/KernelSU/issues/886
    local APK_PATH="system/preload/KernelSU-Next/com.rifsxd.ksunext-mesa==/base.apk"

    echo "Adding KernelSU-Next.apk to preload apps"
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

REPLACE_KERNEL_IMAGES
ADD_KERNELSU_NEXT_MANAGER
rm -rf "$TMP_DIR"
