# [
REPLACE_KERNEL_BINARIES()
{
    local LATEST
    local FLOPPY_TAR
    
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    LATEST=$(curl -s https://api.github.com/repos/FlopKernel-Series/flop_s5e8825_kernel/releases/latest)
    FLOPPY_TAR=$(echo "$LATEST" |
        jq -r '.assets[] | select(.name | test("Vanilla-exynos1280.*\\.tar$")) | .browser_download_url')

    echo "- Downloading $(basename "$FLOPPY_TAR")"
    curl -L -s -o "$TMP_DIR/floppy.tar" "$FLOPPY_TAR"

    echo "- Extracting kernel binaries"
    tar xf "$TMP_DIR/floppy.tar" -C "$TMP_DIR"
    lz4 -q -d "$TMP_DIR/boot.img.lz4" "$TMP_DIR/boot.img"
    lz4 -q -d "$TMP_DIR/vendor_boot.img.lz4" "$TMP_DIR/vendor_boot.img"
    echo "- Replacing kernel binaries"
    [ -f "$WORK_DIR/kernel/boot.img" ] && rm -rf "$WORK_DIR/kernel/boot.img"
    [ -f "$WORK_DIR/kernel/vendor_boot.img" ] && rm -rf "$WORK_DIR/kernel/vendor_boot.img"
    mv "$TMP_DIR/boot.img" "$TMP_DIR/vendor_boot.img" "$WORK_DIR/kernel/"
}
# ]

REPLACE_KERNEL_BINARIES
rm -rf "$TMP_DIR"
