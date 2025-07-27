#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# UN1CA configuration file
ROM_VERSION="2.5.2"
ROM_VERSION+="-$(git rev-parse --short HEAD)"
ROM_CODENAME="Nexus"

# Source ROM firmware
case "$TARGET_SINGLE_SYSTEM_IMAGE" in
    "essi")
        # Galaxy S22 (One UI 7)
        SOURCE_CODENAME="r0s"
        SOURCE_FIRMWARE="SM-S901B/EUX/355416334199386"
        SOURCE_EXTRA_FIRMWARES=()
        SOURCE_API_LEVEL=34
        SOURCE_PRODUCT_FIRST_API_LEVEL=31
        SOURCE_VNDK_VERSION="31"
        SOURCE_HAS_SYSTEM_EXT=false
        SOURCE_SUPER_GROUP_NAME="group_basic"
        # SEC Product Feature
        SOURCE_AUTO_BRIGHTNESS_TYPE="5"
        SOURCE_DVFS_CONFIG_NAME="dvfs_policy_s5e9925_xx"
        SOURCE_NFC_CHIP_VENDOR="NXP"
        SOURCE_FP_SENSOR_CONFIG="google_touch_display_ultrasonic"
        SOURCE_HAS_MASS_CAMERA_APP=false
        SOURCE_HAS_QHD_DISPLAY=false
        SOURCE_HFR_MODE="2"
        SOURCE_HFR_SUPPORTED_REFRESH_RATE="24,10,30,48,60,96,120"
        SOURCE_HFR_DEFAULT_REFRESH_RATE="120"
        SOURCE_DISPLAY_CUTOUT_TYPE="center"
        SOURCE_HFR_SEAMLESS_BRT="84,85"
        SOURCE_HFR_SEAMLESS_LUX="200,1500"
        SOURCE_IS_ESIM_SUPPORTED=true
        SOURCE_HAS_HW_MDNIE=true
        SOURCE_MDNIE_SUPPORTED_MODES="65303"
        SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION="3"
        SOURCE_SUPPORT_WIFI_7=false
        SOURCE_SUPPORT_HOTSPOT_DUALAP=false
        SOURCE_SUPPORT_HOTSPOT_WPA3=true
        SOURCE_SUPPORT_HOTSPOT_6GHZ=false
        SOURCE_SUPPORT_HOTSPOT_WIFI_6=true
        SOURCE_SUPPORT_HOTSPOT_ENHANCED_OPEN=false
        SOURCE_AUDIO_SUPPORT_ACH_RINGTONE=true
        SOURCE_AUDIO_SUPPORT_VIRTUAL_VIBRATION=true
        ;;
    *)
        echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
        return 1
        ;;
esac

return 0
