CERT_PREFIX="aosp"
$ROM_IS_OFFICIAL && CERT_PREFIX="unica"

CERT_SIGNATURE=$(cat "$SRC_DIR/security/${CERT_PREFIX}.x509.pem" | \
    sed '/CERTIFICATE/d' | tr -d '\n' | base64 -d | xxd -p -c 0)

FTP="
system/framework/services.jar/smali_classes2/com/android/server/pm/InstallPackageHelper.smali
"
for f in $FTP; do
    sed -i "s|PUT SIGNATURE HERE|$CERT_SIGNATURE|g" "$APKTOOL_DIR/$f"
done
