# echo "Enabling BSOH in SecSettings..."

# DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"

# FTP="
# system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/BatteryRegulatoryPreferenceController.smali
# system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/SecBatteryFirstUseDatePreferenceController.smali
# system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/SecBatteryInfoFragment.smali
# "
# for f in $FTP; do
#     sed -i "s/SM-A236B/SM-S938B/g" "$APKTOOL_DIR/$f"
# done
