# [
EXTREMEKRNL_REPO="https://github.com/ExtremeXT/990_upstream_v2/"
KERNELSU_MANAGER_APK="https://github.com/KernelSU-Next/KernelSU-Next/releases/download/v1.0.9/KernelSU_Next_v1.0.9_12797-release.apk"

BUILD_KERNEL()
{
    PARENT=$(pwd)
    cd $KERNEL_TMP_DIR

    ./build.sh -m ${TARGET_CODENAME} -k y -r n

    # Fixup for LTE devices
    ./build.sh -m ${TARGET_CODENAME}lte -k n -r n -d y

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
        LOG "- Local branch is up-to-date with remote."
    elif [ "$LOCAL" = "$BASE" ]; then
        LOG "- Fast-forward possible. Pulling."
        git pull --ff-only
    elif [ "$REMOTE" = "$BASE" ]; then
        LOG "- Local branch is ahead of remote. Not doing anything."
    else
	      cd "$PARENT"
        ABORT "Remote history has diverged (possible force-push)."
    fi

    cd "$PARENT"
}

REPLACE_KERNEL_BINARIES()
{
    local KERNEL_TMP_DIR="$KERNEL_TMP_DIR-$TARGET_PLATFORM"
    [ ! -d "$KERNEL_TMP_DIR" ] && mkdir -p "$KERNEL_TMP_DIR"

    LOG_STEP_IN "- Cloning/updating ExtremeKernel"

    # If the kernel dir exists, pull the latest changes.
    # If it does not exist, clone the repo.
    if [ -d "$KERNEL_TMP_DIR/.git" ]; then
        LOG "- Existing git repo found, trying to pull latest changes."
        if ! SAFE_PULL_CHANGES; then
		        ABORT "ERR: Could not pull latest Kernel changes. If you hold local changes, please rebase to the new base. If not, cleaning the kernel_tmp_dir should suffice."
	      fi
    else
        rm -rf "$KERNEL_TMP_DIR"
        git clone "$EXTREMEKRNL_REPO" --single-branch "$KERNEL_TMP_DIR" --recurse-submodules
    fi
    LOG_STEP_OUT

    LOG "- Running the kernel build script."
    BUILD_KERNEL
    rm -f "$WORK_DIR/kernel/"*.img

    # Move the files to the work dir
    mv -f "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/boot.img" "$WORK_DIR/kernel"
    mv -f "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/dtbo.img" "$WORK_DIR/kernel"

    # And now for the LTE DTBOs
    if [[ "$TARGET_CODENAME" != "r8s" && "$TARGET_CODENAME" != "z3s" && "$TARGET_INSTALL_METHOD" != "odin" ]]; then
	      mv -f "$KERNEL_TMP_DIR/build/out/${TARGET_CODENAME}lte/dtbo.img" "$WORK_DIR/kernel/dtbo_lte.img"
    fi

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
# ]

REPLACE_KERNEL_BINARIES
ADD_MANAGER_APK_TO_PRELOAD
