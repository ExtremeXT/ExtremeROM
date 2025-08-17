APPLY_PATCH "system" "system/framework/services.jar" "$MODPATH/0001-Allow-custom-platform-signature.patch"

CERT_PREFIX="aosp"
$ROM_IS_OFFICIAL && CERT_PREFIX="extremerom"

CERT_SIGNATURE=$(cat "$SRC_DIR/security/${CERT_PREFIX}_platform.x509.pem" | sed '/CERTIFICATE/d' | tr -d '\n' | base64 -d | xxd -p -c 0)

sed -i "s|PUT SIGNATURE HERE|$CERT_SIGNATURE|g" "$APKTOOL_DIR/system/framework/services.jar/smali_classes2/com/android/server/pm/InstallPackageHelper.smali"
