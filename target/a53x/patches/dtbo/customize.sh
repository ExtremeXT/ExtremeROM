COPY_TOOLS(){
    cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/dtbo/bin/"* "$TOOLS_DIR"
}

EXTRACT() {
    local DTB="$TMP_DIR/dtb"
    local DTS="$TMP_DIR/dtsi"

    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    
    "$TOOLS_DIR/mkdtimg" dump "$WORK_DIR/kernel/dtbo.img" -b "$DTB" &> /dev/null

    for i in $(seq 0 19); do
        fi="${DTB}.${i}"
        fo="${DTS}.${i}"
        if [ -f "$fi" ]; then
            dtc -I dtb -O dts "$fi" -o "$fo" &> /dev/null
            rm "$fi"
        else
            break
        fi
    done
}

APPLY_DTBO_PATCH() {
    local PATCH="$SRC_DIR/target/$TARGET_CODENAME/patches/dtbo/patches/$1"

    if [ ! -f "$PATCH" ]; then
        echo "File not found: ${PATCH//$SRC_DIR\//}"
        return 1
    fi

    echo "- Applying \"$(grep "^Subject:" "$PATCH" | sed "s/.*PATCH] //")\" to dtbo"
    patch -p1 -s -t -N --no-backup-if-mismatch -d "$TMP_DIR" < "$PATCH" &> /dev/null
    cd - &> /dev/null

    if [ -f "$TMP_DIR/*.rej" ]; then
        echo "ERR: Found *.rej files in $TMP_DIR"
        exit 1
    fi
}

CREATE_CFG() {
    {
        echo "a53x_eur_open_w00_r00.dtbo"
        echo "    custom0=0x00000000"
        echo "    custom1=0x00000000"
        echo ""
        echo "a53x_eur_open_w00_r01.dtbo"
        echo "    custom0=0x00000001"
        echo "    custom1=0x00000001"
        echo ""
        echo "a53x_eur_open_w00_r02.dtbo"
        echo "    custom0=0x00000002"
        echo "    custom1=0x00000004"
        echo ""
        echo "a53x_eur_open_w00_r05.dtbo"
        echo "    custom0=0x00000005"
        echo "    custom1=0x00000005"
        echo ""
        echo "a53x_eur_open_w00_r06.dtbo"
        echo "    custom0=0x00000006"
        echo "    custom1=0x00000020"
    } >> "$TMP_DIR/$TARGET_CODENAME.cfg"
}

PACK_TO_DTBO() {
    "$TOOLS_DIR/dtc" -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r00.dtbo" "$TMP_DIR/dtsi.0" &> /dev/null
    "$TOOLS_DIR/dtc" -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r01.dtbo" "$TMP_DIR/dtsi.1" &> /dev/null
    "$TOOLS_DIR/dtc" -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r02.dtbo" "$TMP_DIR/dtsi.2" &> /dev/null
    "$TOOLS_DIR/dtc" -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r05.dtbo" "$TMP_DIR/dtsi.3" &> /dev/null
    "$TOOLS_DIR/dtc" -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r06.dtbo" "$TMP_DIR/dtsi.4" &> /dev/null
}

PACK_TO_IMG() {
    "$TOOLS_DIR/mkdtimg" cfg_create "$TMP_DIR/dtbo.img" "$TMP_DIR/$TARGET_CODENAME.cfg" -d "$TMP_DIR" &> /dev/null
}

COPY_TOOLS
echo "- Extract dtbo"
EXTRACT
APPLY_DTBO_PATCH "0001-Fix-Adaptive-Refresh-Rate-Color-Flickering.patch"
CREATE_CFG
echo "- Repack dtbo"
PACK_TO_DTBO
PACK_TO_IMG
[ -f "$WORK_DIR/kernel/dtbo.img" ] && rm -rf "$WORK_DIR/kernel/dtbo.img"
echo "- Copy new dtbo.img"
cp -fa "$TMP_DIR/dtbo.img" "$WORK_DIR/kernel/dtbo.img"
rm -rf "$TMP_DIR"
