#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

BOARD_COMMON=msm8916-common

DEVICES_A3="a3lte a33g a3ulte"
DEVICES_A5="a5ltechn a5ltectc"
DEVICES_GPRIME="fortuna3g fortunave3g fortunalteub gprimelte gprimeltexx gprimeltespr gprimeltetfnvzw gprimeltezt gprimeltectc"
DEVICES_GTE="gtelwifiue gtesqltespr gt510wifi"
DEVICES_J3="j3ltectc j3ltespr"
DEVICES_J3XPRO="j3xprolte"
DEVICES_J5="j53gxx j5lte j5ltechn j5nlte"
DEVICES_J5X="j5xnlte j5xlte j5xltecmcc"
DEVICES_J7="j7ltespr j7ltechn"
DEVICES_O7="o7prolte on7ltechn"
DEVICES_SERRANO="serranovelte serranove3g"

DEVICES_ALL="$DEVICES_A3 $DEVICES_A5 $DEVICES_GPRIME $DEVICES_GTE $DEVICES_J3 $DEVICES_J3XPRO \
	$DEVICES_J5 $DEVICES_J5X $DEVICES_J7 $DEVICES_O7 $DEVICES_SERRANO"

VENDOR=samsung

INITIAL_COPYRIGHT_YEAR=2017

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..
DEVICE_DIR="$MY_DIR"/../$DEVICE
DEVICE_COMMON_DIR="$MY_DIR"/../$DEVICE_COMMON

# determine which blob dirs to set up
if [ -z "$SETUP_BOARD_COMMON_DIR" ]; then
    SETUP_BOARD_COMMON_DIR=1
fi

if [ -z "$SETUP_DEVICE_DIR" ]; then
    SETUP_DEVICE_DIR=0
fi

if [ -z "$SETUP_DEVICE_COMMON_DIR" ]; then
    SETUP_DEVICE_COMMON_DIR=0
fi

HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ "$SETUP_DEVICE_COMMON_DIR" -eq 1 ] && [ -s $DEVICE_COMMON_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE_COMMON" "$VENDOR" "$LINEAGE_ROOT" true

    # Copyright headers and guards
    write_headers "$DEVICES"

    # The standard device blobs
    write_makefiles $DEVICE_COMMON_DIR/proprietary-files.txt

    # We are done!
    write_footers
fi

if [ "$SETUP_DEVICE_DIR" -eq 1 ] && [ -s $DEVICE_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT"

    # Copyright headers and guards
    write_headers

    # The standard device blobs
    write_makefiles $DEVICE_DIR/proprietary-files.txt

    # We are done!
    write_footers
fi

if  [ "$SETUP_BOARD_COMMON_DIR" -eq 1 ]; then
   # set up the board common makefiles
   DEVICE_COMMON=$BOARD_COMMON

   # Initialize the helper
   setup_vendor "$BOARD_COMMON" "$VENDOR" "$LINEAGE_ROOT" true

   # Copyright headers and guards
   write_headers "$DEVICES_ALL"

   write_makefiles "$MY_DIR"/proprietary-files.txt

   # Finish
   write_footers
fi
