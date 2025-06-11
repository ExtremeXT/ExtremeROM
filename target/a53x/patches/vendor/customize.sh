SKIPUNZIP=1
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

## Tee
# A536E
[ -d "$WORK_DIR/vendor/tee_cis" ] && rm -rf "$WORK_DIR/vendor/tee_cis"
[ -d "$WORK_DIR/vendor/tee" ] && rm -rf "$WORK_DIR/vendor/tee"
cp -rfa "$TARGET_FIRMWARE_PATH/vendor/tee" "$WORK_DIR/vendor/tee_cis"
mkdir -p "$WORK_DIR/vendor/tee"

# A536B
[ -d "$WORK_DIR/vendor/tee_eur" ] && rm -rf "$WORK_DIR/vendor/tee_eur"
cp -fa --preserve=all "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/tee" "$WORK_DIR/vendor/tee_eur"

## Firmware
# A536E
if [ ! -d "$WORK_DIR/vendor/firmware/cis" ]; then
    mkdir -p "$WORK_DIR/vendor/firmware/cis"
    mv -f "$WORK_DIR/vendor/firmware/AP_AUDIO_SLSI.bin" "$WORK_DIR/vendor/firmware/AP_AUDIO_SLSI-cis.bin"
    mv -f "$WORK_DIR/vendor/firmware/APDV_AUDIO_SLSI.bin" "$WORK_DIR/vendor/firmware/APDV_AUDIO_SLSI-cis.bin"
    mv -f "$WORK_DIR/vendor/firmware/calliope_sram.bin" "$WORK_DIR/vendor/firmware/cis/calliope_sram.bin"
    mv -f "$WORK_DIR/vendor/firmware/mfc_fw.bin" "$WORK_DIR/vendor/firmware/cis/mfc_fw.bin"
    mv -f "$WORK_DIR/vendor/firmware/os.checked.bin" "$WORK_DIR/vendor/firmware/cis/os.checked.bin"
    mv -f "$WORK_DIR/vendor/firmware/NPU.bin" "$WORK_DIR/vendor/firmware/cis/NPU.bin"
    mv -f "$WORK_DIR/vendor/firmware/vts.bin" "$WORK_DIR/vendor/firmware/cis/vts.bin"
    touch "$WORK_DIR/vendor/firmware/AP_AUDIO_SLSI.bin"
    touch "$WORK_DIR/vendor/firmware/APDV_AUDIO_SLSI.bin"
    touch "$WORK_DIR/vendor/firmware/calliope_sram.bin"
    touch "$WORK_DIR/vendor/firmware/mfc_fw.bin"
    touch "$WORK_DIR/vendor/firmware/os.checked.bin"
    touch "$WORK_DIR/vendor/firmware/NPU.bin"
    touch "$WORK_DIR/vendor/firmware/vts.bin"
fi

# A536B
[ -d "$WORK_DIR/vendor/firmware/eur" ] && rm -rf "$WORK_DIR/vendor/firmware/eur"
cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/firmware" "$WORK_DIR/vendor/firmware/eur"
mv -f "$WORK_DIR/vendor/firmware/eur/AP_AUDIO_SLSI.bin" "$WORK_DIR/vendor/firmware/AP_AUDIO_SLSI-eur.bin"
mv -f "$WORK_DIR/vendor/firmware/eur/APDV_AUDIO_SLSI.bin" "$WORK_DIR/vendor/firmware/APDV_AUDIO_SLSI-eur.bin"

## Rc (unify.rc)
[ -f "$WORK_DIR/vendor/etc/init/unify.rc" ] && rm -f "$WORK_DIR/vendor/etc/init/unify.rc" 

# A536E
{
    echo "# SM-A536E (TPA)"
    echo "on early-init && property:ro.boot.em.model=SM-A536E"
    echo "mount none /vendor/firmware/cis/mfc_fw.bin /vendor/firmware/mfc_fw.bin bind"
    echo "mount none /vendor/firmware/cis/NPU.bin /vendor/firmware/NPU.bin bind"
    echo "mount none /vendor/firmware/cis/os.checked.bin /vendor/firmware/os.checked.bin bind"
    echo "mount none /vendor/firmware/cis/vts.bin /vendor/firmware/vts.bin bind"
    echo "mount none /vendor/firmware/cis/calliope_sram.bin /vendor/firmware/calliope_sram.bin bind"
    echo "mount none /vendor/tee_cis /vendor/tee bind"
} >> "$WORK_DIR/vendor/etc/init/unify.rc"

# A536B
{
    echo ""
    echo "# SM-A536B (EUX"
    echo "on early-init && property:ro.boot.em.model=SM-A536B"
    echo "mount none /vendor/firmware/eur/mfc_fw.bin /vendor/firmware/mfc_fw.bin bind"
    echo "mount none /vendor/firmware/eur/NPU.bin /vendor/firmware/NPU.bin bind"
    echo "mount none /vendor/firmware/eur/os.checked.bin /vendor/firmware/os.checked.bin bind"
    echo "mount none /vendor/firmware/eur/vts.bin /vendor/firmware/vts.bin bind"
    echo "mount none /vendor/firmware/eur/calliope_sram.bin /vendor/firmware/calliope_sram.bin bind"
    echo "mount none /vendor/tee_eur /vendor/tee bind"
} >> "$WORK_DIR/vendor/etc/init/unify.rc"

# Sepolicy
if ! grep -q "tee_file (dir (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_31_0 tee_file (dir (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 tee_file (dir (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_fw_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_fw_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_npu_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_npu_firmware_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi

### Selinux
## Firmware
# A536E
if ! grep -q "vendor/firmware/cis" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/firmware/cis u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/AP_AUDIO_SLSI-cis\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/APDV_AUDIO_SLSI-cis\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/cis/calliope_sram\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/cis/mfc_fw\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/cis/NPU\.bin u:object_r:vendor_npu_firmware_file:s0"
        echo "/vendor/firmware/cis/os.checked\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/cis/vts\.bin u:object_r:vendor_fw_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi

if ! grep -q "vendor/firmware/cis" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/firmware/cis 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/AP_AUDIO_SLSI-cis.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/APDV_AUDIO_SLSI-cis.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/cis/calliope_sram.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/cis/mfc_fw.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/cis/NPU.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/cis/os.checked.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/cis/vts.bin 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi

# A536B
if ! grep -q "vendor/firmware/eur" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/firmware/eur u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/AP_AUDIO_SLSI-eur\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/APDV_AUDIO_SLSI-eur\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/eur/calliope_sram\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/eur/mfc_fw\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/eur/NPU\.bin u:object_r:vendor_npu_firmware_file:s0"
        echo "/vendor/firmware/eur/os.checked\.bin u:object_r:vendor_fw_file:s0"
        echo "/vendor/firmware/eur/vts\.bin u:object_r:vendor_fw_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi

if ! grep -q "vendor/firmware/eur" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/firmware/eur 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/AP_AUDIO_SLSI-eur.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/APDV_AUDIO_SLSI-eur.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/eur/calliope_sram.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/eur/mfc_fw.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/eur/NPU.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/eur/os.checked.bin 0 0 644 capabilities=0x0"
        echo "vendor/firmware/eur/vts.bin 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi

## Rc (unify.rc)
if ! grep -q "unify" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/etc/init/unify\.rc u:object_r:vendor_configs_file:s0"
        echo "/vendor/tee u:object_r:tee_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi

if ! grep -q "unify" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/etc/init/unify.rc 0 0 644 capabilities=0x0"
        echo "vendor/tee 0 2000 755 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi

## Tee
# A536E
if ! grep "/vendor/tee_cis u:object_r:tee_file:s0" "$WORK_DIR/configs/file_context-vendor"; then
    sed -i "s./vendor/tee./vendor/tee_cis.g" "$WORK_DIR/configs/file_context-vendor"
    echo "/vendor/tee u:object_r:tee_file:s0" >> "$WORK_DIR/configs/file_context-vendor"
fi

if ! grep "vendor/tee_cis 0 2000 755 capabilities=0x0" "$WORK_DIR/configs/fs_config-vendor"; then
    sed -i "s.vendor/tee.vendor/tee_cis.g" "$WORK_DIR/configs/fs_config-vendor"
    echo "vendor/tee 0 2000 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-vendor"
fi

# A536B
TEE_BLOBS=(
00000000-0000-0000-0000-000000010081
00000000-0000-0000-0000-000000020081
00000000-0000-0000-0000-000000534b4d
00000000-0000-0000-0000-000048444350
00000000-0000-0000-0000-0000534b504d
00000000-0000-0000-0000-0050524f4341
00000000-0000-0000-0000-0053545354ab
00000000-0000-0000-0000-00575644524d
00000000-0000-0000-0000-42494f535542
00000000-0000-0000-0000-46494e474502
00000000-0000-0000-0000-4662436b6d52
00000000-0000-0000-0000-474154454b45
00000000-0000-0000-0000-4b45594d5354
00000000-0000-0000-0000-4d5053545549
00000000-0000-0000-0000-4d704e434954
00000000-0000-0000-0000-4d70536b566e
00000000-0000-0000-0000-4d7073534d43
00000000-0000-0000-0000-4d7073617574
00000000-0000-0000-0000-505256544545
00000000-0000-0000-0000-5345435f4652
00000000-0000-0000-0000-53454d655345
00000000-0000-0000-0000-54412d48444d
00000000-0000-0000-0000-54496473706c
00000000-0000-0000-0000-544974684c6c
00000000-0000-0000-0000-564c544b5052
00000000-0000-0000-0000-656e676d6f64
00000000-0000-0000-0000-657365636f6d
00000000-0000-0000-0000-6b6e78677564
00000000-0000-0000-0000-6d706f667376
00000000-0000-0000-0000-6d73745f5441
)

if ! grep -q "vendor/tee_eur" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/tee_eur u:object_r:tee_file:s0"
        for b in "${TEE_BLOBS[@]}"; do
                echo "/vendor/tee_eur/$b u:object_r:tee_file:s0"
        done
        echo "/vendor/tee_eur/driver u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/driver/00000000-0000-0000-0000-494363447256 u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/driver/00000000-0000-0000-0000-4d53546d7374 u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/driver/00000000-0000-0000-0000-53626f786476 u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/driver/00000000-0000-0000-0000-564c544b4456 u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/ffffffff-0000-0000-0000-000000000030 u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/tui u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/tui/resolution_common u:object_r:tee_file:s0"
        echo "/vendor/tee_eur/tui/resolution_common/ID00000100 u:object_r:tee_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi

if ! grep -q "vendor/tee_eur" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/tee_eur 0 2000 755 capabilities=0x0"
        for b in "${TEE_BLOBS[@]}"; do
            echo "vendor/tee_eur/$b 0 0 644 capabilities=0x0"
        done
        echo "vendor/tee_eur/driver 0 2000 755 capabilities=0x0"
        echo "vendor/tee_eur/driver/00000000-0000-0000-0000-494363447256 0 0 644 capabilities=0x0"
        echo "vendor/tee_eur/driver/00000000-0000-0000-0000-4d53546d7374 0 0 644 capabilities=0x0"
        echo "vendor/tee_eur/driver/00000000-0000-0000-0000-53626f786476 0 0 644 capabilities=0x0"
        echo "vendor/tee_eur/driver/00000000-0000-0000-0000-564c544b4456 0 0 644 capabilities=0x0"
        echo "vendor/tee_eur/ffffffff-0000-0000-0000-000000000030 0 0 644 capabilities=0x0"
        echo "vendor/tee_eur/tui 0 2000 755 capabilities=0x0"
        echo "vendor/tee_eur/tui/resolution_common 0 2000 755 capabilities=0x0"
        echo "vendor/tee_eur/tui/resolution_common/ID00000100 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi
