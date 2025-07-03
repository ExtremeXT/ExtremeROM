# [
EXTREMEKRNL_REPO="https://github.com/ExtremeXT/M62-backport/"
KERNELSU_MANAGER_APK="https://github.com/KernelSU-Next/KernelSU-Next/releases/download/v1.0.7/KernelSU_Next_v1.0.7_12602-release.apk"

BUILD_KERNEL()
{
    PARENT=$(pwd)
    cd "$KERNEL_TMP_DIR"

    ./build.sh -m ${TARGET_CODENAME} -k y -d n

    cd $PARENT
}

SAFE_PULL_CHANGES()
{
    PARENT=$(pwd)
    cd "$KERNEL_TMP_DIR"

    set -eo pipefail

    git fetch origin

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)
    BASE=$(git merge-base @ origin/main)

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

REPLACE_KERNEL_BINARIES()
{
    local KERNEL_TMP_DIR="$KERNEL_TMP_DIR-$TARGET_PLATFORM"
    [ ! -d "$KERNEL_TMP_DIR" ] && mkdir -p "$KERNEL_TMP_DIR"

    echo "Cloning/updating ExtremeKernel"

    # If the kernel dir exists, pull the latest changes.
    # If it does not exist, clone the repo.
    if [ -d "$KERNEL_TMP_DIR/.git" ]; then
        echo "Existing git repo found, trying to pull latest changes."
        if ! SAFE_PULL_CHANGES; then
		echo "ERR: Could not pull latest Kernel changes."
		echo "If you hold local changes, please rebase to the new base."
		echo "If not, cleaning the kernel_tmp_dir should suffice."
		return 1
	fi
    else
        rm -rf "$KERNEL_TMP_DIR"
        git clone "$EXTREMEKRNL_REPO" --single-branch "$KERNEL_TMP_DIR" --recurse-submodules
    fi

    echo "Running the kernel build script."
    BUILD_KERNEL
    rm -f "$WORK_DIR/kernel/"*.img

    # Move the files to the work dir
    mv -v "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/boot.img" "$WORK_DIR/kernel"
    mv -v "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/dtbo.img" "$WORK_DIR/kernel"
    mv -v "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/dtb.img" "$WORK_DIR/kernel"

    # Usually we would delete the temporary directory.
    # However, the Kernel has its own build system that
    # will track changes made to the source by itself.
    # Clean building the kernel also takes a long time.
    # So, keep the kernel temp dir.
}

ADD_MANAGER_APK_TO_PRELOAD()
{
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
# ]

REPLACE_KERNEL_BINARIES
ADD_MANAGER_APK_TO_PRELOAD
