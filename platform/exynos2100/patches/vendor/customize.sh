SKIPUNZIP=1
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_MODEL="$(echo "$TARGET_FIRMWARE" | cut -d'/' -f1)"
TARGET_MODEL_SHORT="$(echo "$TARGET_FIRMWARE" | cut -d'/' -f1 | cut -c1-7)"

# https://github.com/salvogiangri/UN1CA/blob/fifteen/unica/mods/bootanim/customize.sh
SUPPORTED="o1s"

if ! echo "$SUPPORTED" | grep -q -w "$TARGET_CODENAME"; then
    echo "Unsupported device detected, skipping unification."
    exit 0
fi

echo "Adding support for other $TARGET_CODENAME models"
## Tee
# Target Model
DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"
cp -rfa "$TARGET_FIRMWARE_PATH/vendor/tee" "$WORK_DIR/vendor/tee/$TARGET_MODEL"

# Other Models
cp -rfa "$SRC_DIR/platform/exynos2100/patches/vendor/vendor/tee/$TARGET_MODEL_SHORT"* "$WORK_DIR/vendor/tee"

## Firmware
# Target Model
if [ ! -d "$WORK_DIR/vendor/firmware/$TARGET_MODEL" ]; then
    BLOBS=( "APDV_AUDIO_SLSI.bin"  "AP_AUDIO_SLSI.bin"  "bcm4375B1_murata.hcd"  "bcm4375B1_semco.hcd"
            "bcm4375B1_semco_sem.hcd"  "calliope_sram.bin"  "dsp_master.bin"  "is_rta.bin"
            "mfc_fw.bin"  "NPU.bin"  "nfc/libsn100u_fw.so"  "nvram.txt_1rh_es43_b1"
            "nvram.txt_CS01_semco_b1"  "rxse.bin"  "SoundBoosterParam.bin"  "vts.bin"
          )

    mkdir -p "$WORK_DIR/vendor/firmware/$TARGET_MODEL"
    for b in "${BLOBS[@]}"; do
        mv -f "$WORK_DIR/vendor/firmware/${b}.bin" "$WORK_DIR/vendor/firmware/$TARGET_MODEL/${b}.bin"
        touch "$WORK_DIR/vendor/firmware/${b}.bin"
    done
fi

# Other Models
cp -rfa "$SRC_DIR/platform/exynos2100/patches/vendor/vendor/firmware/$TARGET_MODEL_SHORT"* "$WORK_DIR/vendor/firmware"

## Init (init.$TARGET_CODENAME.unify.rc)
ADD_TO_WORK_DIR "$SRC_DIR/platform/exynos2100/patches/vendor" "vendor" "etc/init/init.${TARGET_CODENAME}.unify.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"

# Sepolicy
if ! grep -q "tee_file (dir (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_31_0 tee_file (dir (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 tee_file (dir (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_fw_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_fw_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_npu_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_npu_firmware_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi

# File Context
cat "$SRC_DIR/platform/exynos2100/patches/vendor/file_context-vendor-${TARGET_CODENAME}" >> "$WORK_DIR/configs/file_context-vendor"

# Fs Config
cat "$SRC_DIR/platform/exynos2100/patches/vendor/fs_config-vendor-${TARGET_CODENAME}" >> "$WORK_DIR/configs/fs_config-vendor"

