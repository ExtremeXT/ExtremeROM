# [
APPLY_PATCH()
{
    local PATCH
    local OUT

    DECODE_APK "$1"

    cd "$APKTOOL_DIR/$1"
    PATCH="$SRC_DIR/platform/exynos2200/patches/miscs/$2"
    OUT="$(patch -p1 -s -t -N --dry-run < "$PATCH")" \
        || echo "$OUT" | grep -q "Skipping patch" || false
    patch -p1 -s -t -N --no-backup-if-mismatch < "$PATCH" &> /dev/null || true
    cd - &> /dev/null
}

# Encryption
echo "Disabling encryption"
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.s5e9925")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2//g" "$WORK_DIR/vendor/etc/fstab.s5e9925"

# 60Hz refresh rate for S22/S22+
if [[ "$TARGET_CODENAME" = "r0s" || "$TARGET_CODENAME" = "g0s" ]]; then
    echo "Applying refresh rate patch"

    DECODE_APK "system/framework/framework.jar"

    APPLY_PATCH "system/framework/framework.jar" "hfr/0001-Fix-60hz-refresh-rate.patch"
fi