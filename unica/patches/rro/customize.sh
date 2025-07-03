if [[ -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]]; then
    DECODE_APK "/product/overlay/framework-res__r12sxxx__auto_generated_rro_product.apk"

    echo "Applying stock overlay configs"
    rm -rf "$APKTOOL_DIR/product/overlay/framework-res__r12sxxx__auto_generated_rro_product.apk/res"
    cp -a --preserve=all \
        "$SRC_DIR/target/$TARGET_CODENAME/overlay" \
        "$APKTOOL_DIR/product/overlay/framework-res__r12sxxx__auto_generated_rro_product.apk/res"
fi

# TODO: Add a proper check if we need to remove this
DECODE_APK "/product/overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk"
sed -i -e "/config_enableDisplayCutoutProtection/d" -e "/config_enableRoundedCorner/d" "$APKTOOL_DIR/product/overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk/res/values/bools.xml"
rm "$APKTOOL_DIR/product/overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk/res/values/dimens.xml"
rm "$APKTOOL_DIR/product/overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk/res/values/public.xml"
rm "$APKTOOL_DIR/product/overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk/res/drawable/rounded.xml"
