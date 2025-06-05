BUILD_KERNEL()
{
    local PARENT="$(pwd)"
    cd "$KERNEL_TMP_DIR/floppy"

    ./do_build.sh

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

REPLACE_KERNEL_BINARIES()
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

    echo "Running the kernel build script."
    BUILD_KERNEL

    # Move the files to the work dir
    mv -fv "$KERNEL_TMP_DIR/floppy/kernel_build/boot.img" "$WORK_DIR/kernel"
    mv -fv "$KERNEL_TMP_DIR/floppy/kernel_build/vendor_boot.img" "$WORK_DIR/kernel"
}

REPLACE_KERNEL_BINARIES
rm -rf "$TMP_DIR"