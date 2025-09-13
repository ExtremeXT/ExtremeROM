# [
EXTREMEKRNL_REPO="https://github.com/xfwdrev/android_kernel_samsung_ex2100/"

BUILD_KERNEL()
{
    PARENT=$(pwd)
    cd $KERNEL_TMP_DIR

    ./build.sh -m ${TARGET_CODENAME} -k y

    cd $PARENT
}

SAFE_PULL_CHANGES()
{
    PARENT=$(pwd)
    cd "$KERNEL_TMP_DIR"

    set -eo pipefail

    git fetch origin

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/12-upstream)
    BASE=$(git merge-base @ origin/12-upstream)

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
    mv -f "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/vendor_boot.img" "$WORK_DIR/kernel"

    # Usually we would delete the temporary directory.
    # However, the Kernel has its own build system that
    # will track changes made to the source by itself.
    # Clean building the kernel also takes a long time.
    # So, keep the kernel temp dir.
}
# ]

REPLACE_KERNEL_BINARIES
