#!/usr/bin/env bash
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

# shellcheck disable=SC2001

set -Ee

# [
GET_LATEST_FIRMWARE()
{
    curl -s --retry 5 --retry-delay 5 "https://fota-cloud-dn.ospserver.net/firmware/$REGION/$MODEL/version.xml" \
        | grep latest | sed 's/^[^>]*>//' | sed 's/<.*//'
}
#]

if [ "$#" != 1 ]; then
    echo "Usage: update_prebuilt_blobs <path>"
    exit 1
fi

if [ ! -d "$SRC_DIR/$1" ]; then
    echo "Folder not found: $SRC_DIR/$1"
    exit 1
fi

MODULE="$SRC_DIR/$1"
BLOBS=""
FIRMWARE=""

if [ -d "$MODULE/system" ]; then
    BLOBS+="$(find "$MODULE/system" -type f)"
    BLOBS="${BLOBS//$MODULE/system}"
fi
if [ -d "$MODULE/product" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/product" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi
if [ -d "$MODULE/vendor" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/vendor" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi
if [ -d "$MODULE/system_ext" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/system_ext" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi

case "$1" in
    "prebuilts/samsung/a26xxx")
        FIRMWARE="SM-A266B/EUX/350439761193107"
        ;;
    "prebuilts/samsung/a73xqxx")
        FIRMWARE="SM-A736B/SEK/352828291234563"
        ;;
    "prebuilts/samsung/b6qxxx")
        FIRMWARE="SM-F956B/EUX/351451341950251"
        ;;
    "prebuilts/samsung/dm3qxxx")
        FIRMWARE="SM-S918B/EUX/350196551234562"
        ;;
    "prebuilts/samsung/e1sxxx")
        FIRMWARE="SM-S921B/EUX/350070120202022"
        ;;
    "prebuilts/samsung/e2sxxx")
        FIRMWARE="SM-S926B/EUX/355622360977567"
        ;;
    "prebuilts/samsung/gts10fewifixx")
        FIRMWARE="SM-X520/EUX/R52Y30G0M0T"
        ;;
    "prebuilts/samsung/p3sxxx")
        FIRMWARE="SM-G998B/AUT/352731458300849"
        ;;
    "prebuilts/samsung/pa3qzcx")
        FIRMWARE="SM-S9380/CHC/355534491000674"
        ;;
    "prebuilts/samsung/r0qxxx")
        FIRMWARE="SM-S901E/INS/350999641234561"
        ;;
    "prebuilts/samsung/r12sxxx")
        FIRMWARE="SM-S721B/EUX/351273090276500"
        ;;
    *)
        echo "Firmware not set for path $1"
        exit 1
        ;;
esac

MODEL=$(echo -n "$FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$FIRMWARE" | cut -d "/" -f 2)

[ -z "$(GET_LATEST_FIRMWARE)" ] && exit 1
if [[ "$(GET_LATEST_FIRMWARE)" == "$(cat "$MODULE/.current")" ]]; then
    echo "Nothing to do."
    exit 0
fi

echo -e "Updating $MODULE blobs\n"

export SOURCE_FIRMWARE="$FIRMWARE"
export TARGET_FIRMWARE="$FIRMWARE"
export SOURCE_EXTRA_FIRMWARES=""
export TARGET_EXTRA_FIRMWARES=""
"$SRC_DIR/scripts/download_fw.sh"
"$SRC_DIR/scripts/extract_fw.sh"

for i in $BLOBS; do
    if [[ "$i" == *[0-9] ]]; then
        i="${i%.*}"
    fi
    OUT="$MODULE/${i//system\/system\///system/}"

    [[ -e "$FW_DIR/${MODEL}_${REGION}/$i" ]] || continue

    if [[ "$(wc -c "$FW_DIR/${MODEL}_${REGION}/$i" | cut -d " " -f 1)" -gt "52428800" ]]; then
        rm "$OUT."*
        split -d -b 52428800 "$FW_DIR/${MODEL}_${REGION}/$i" "$OUT."
    else
        cp -a "$FW_DIR/${MODEL}_${REGION}/$i" "$OUT"
    fi
done

cp -a "$FW_DIR/${MODEL}_${REGION}/.extracted" "$MODULE/.current"

exit 0
