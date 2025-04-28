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
ROM_VERSION="1.0.0-nxt"
ROM_VERSION+="-$(git rev-parse --short HEAD)"
ROM_CODENAME="Nexus"

# Source ROM firmware
case "$TARGET_SINGLE_SYSTEM_IMAGE" in
    "essi")
        # Galaxy S25 Ultra (One UI 7)
        SOURCE_CODENAME="pa3q"
        SOURCE_FIRMWARE="SM-S938B/SIN/356597450035295"
        SOURCE_EXTRA_FIRMWARES=()
        SOURCE_API_LEVEL=35
        SOURCE_PRODUCT_FIRST_API_LEVEL=35
        SOURCE_VNDK_VERSION="none"
        SOURCE_HAS_SYSTEM_EXT=true
        SOURCE_SUPER_GROUP_NAME="qti_dynamic_partitions"
        # SEC Product Feature
        SOURCE_AUTO_BRIGHTNESS_TYPE="5"
        SOURCE_DVFS_CONFIG_NAME="dvfs_policy_default"
        SOURCE_NFC_CHIP_VENDOR="NXP"
        SOURCE_FP_SENSOR_CONFIG="google_touch_display_ultrasonic,wireless_charging_notifier"
        SOURCE_HAS_MASS_CAMERA_APP=false
        SOURCE_HAS_QHD_DISPLAY=true
        SOURCE_HFR_MODE="3"
        SOURCE_HFR_SUPPORTED_REFRESH_RATE="24,10,30,48,60,80,120"
        SOURCE_HFR_DEFAULT_REFRESH_RATE="120"
        SOURCE_DISPLAY_CUTOUT_TYPE="center"
        SOURCE_IS_ESIM_SUPPORTED=true
        SOURCE_MDNIE_SUPPORTED_MODES="65303"
        SOURCE_SUPPORT_CUTOUT_PROTECTION=false
        SOURCE_SUPPORT_WIFI_7=true
        SOURCE_SUPPORT_HOTSPOT_DUALAP=true
        SOURCE_SUPPORT_HOTSPOT_WPA3=true
        SOURCE_SUPPORT_HOTSPOT_6GHZ=true
        SOURCE_SUPPORT_HOTSPOT_WIFI_6=true
        ;;
    *)
        echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
        return 1
        ;;
esac

return 0
