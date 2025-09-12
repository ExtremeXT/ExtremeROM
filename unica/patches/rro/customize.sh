SYSTEM_NAME="$(GET_PROP "$WORK_DIR/system/system/build.prop" "ro.product.system.name")"

if [[ -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]]; then
    DECODE_APK "product" "overlay/framework-res__${SYSTEM_NAME}__auto_generated_rro_product.apk"

    LOG "- Applying stock overlay configs"
    rm -rf "$APKTOOL_DIR/product/overlay/framework-res__${SYSTEM_NAME}__auto_generated_rro_product.apk/res"
    cp -fa \
        "$SRC_DIR/target/$TARGET_CODENAME/overlay" \
        "$APKTOOL_DIR/product/overlay/framework-res__${SYSTEM_NAME}__auto_generated_rro_product.apk/res"
fi

# TODO: Add a proper check if we need to remove this
DECODE_APK "product" "overlay/SystemUI__${SYSTEM_NAME}__auto_generated_rro_product.apk"
rm "$APKTOOL_DIR/product/overlay/SystemUI__${SYSTEM_NAME}__auto_generated_rro_product.apk/res/values/public.xml"
rm "$APKTOOL_DIR/product/overlay/SystemUI__${SYSTEM_NAME}__auto_generated_rro_product.apk/res/drawable/rounded.xml"
