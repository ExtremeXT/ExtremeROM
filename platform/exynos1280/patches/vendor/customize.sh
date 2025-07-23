SKIPUNZIP=1
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_MODEL="$(echo "$TARGET_FIRMWARE" | cut -d'/' -f1)"
TARGET_MODEL_SHORT="$(echo "$TARGET_FIRMWARE" | cut -d'/' -f1 | cut -c1-7)"

## GPU Blobs
LOG_STEP_IN "- Adding newer GPU Blobs"
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "etc/permissions" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "etc/snap_gpu_kernel_64.bin" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "etc/snaplite_cache.bin" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "lib" 0 0 644 "u:object_r:same_process_hal_file:s0"
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "lib64" 0 0 644 "u:object_r:same_process_hal_file:s0"
LOG_STEP_OUT

# https://github.com/salvogiangri/UN1CA/blob/fifteen/unica/mods/bootanim/customize.sh
SUPPORTED="a53x"

if ! echo "$SUPPORTED" | grep -q -w "$TARGET_CODENAME"; then
    LOG "- Unsupported device detected, skipping unification."
    exit 0
fi

LOG_STEP_IN "- Adding support for other $TARGET_CODENAME models"
## Firmware
# Target Model
if [ ! -d "$WORK_DIR/vendor/firmware/$TARGET_MODEL" ]; then
    BLOBS=( "calliope_sram" "mfc_fw" "os.checked" "NPU" "vts" )
    [ "$TARGET_CODENAME" != "m34x" ] && BLOBS+=( "AP_AUDIO_SLSI" "APDV_AUDIO_SLSI" )

    mkdir -p "$WORK_DIR/vendor/firmware/$TARGET_MODEL"
    for b in "${BLOBS[@]}"; do
        mv -f "$WORK_DIR/vendor/firmware/${b}.bin" "$WORK_DIR/vendor/firmware/$TARGET_MODEL/${b}.bin"
        touch "$WORK_DIR/vendor/firmware/${b}.bin"
    done
fi

# Other Models
cp -rfa "$SRC_DIR/platform/exynos1280/patches/vendor/vendor/firmware/$TARGET_MODEL_SHORT"* "$WORK_DIR/vendor/firmware"

## Init (init.${TARGET_CODENAME}.unify.rc)
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos1280/patches/vendor" "vendor" "etc/init/init.${TARGET_CODENAME}.unify.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"

## Tee
# Target Model
DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"
cp -rfa "$TARGET_FIRMWARE_PATH/vendor/tee" "$WORK_DIR/vendor/tee/$TARGET_MODEL"

# Other Models
cp -rfa "$SRC_DIR/platform/exynos1280/patches/vendor/vendor/tee/$TARGET_MODEL_SHORT"* "$WORK_DIR/vendor/tee"

## Sepolicy
if ! grep -q "tee_file (dir (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_31_0 tee_file (dir (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 tee_file (dir (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_fw_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_fw_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_npu_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_npu_firmware_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi

# File Context
cat "$SRC_DIR/platform/exynos1280/patches/vendor/file_context-vendor-${TARGET_CODENAME}" >> "$WORK_DIR/configs/file_context-vendor"

# Fs Config
cat "$SRC_DIR/platform/exynos1280/patches/vendor/fs_config-vendor-${TARGET_CODENAME}" >> "$WORK_DIR/configs/fs_config-vendor"

LOG_STEP_OUT
