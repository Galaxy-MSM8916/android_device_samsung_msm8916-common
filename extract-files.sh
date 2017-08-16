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

function print_help() {
    echo "Usage: `basename $0` [OPTIONS] "
    echo "  -b | --setup-all  Set up all dirs (device and device-commons)"
    echo "  -p | --path  Vendor blob source path (to ota package or system folder)"
    echo "  -s | --section  Section to extract"
    echo "  -c | --clean-vendor  Clean vendor dirs"
    echo "  -h | --help Print this text"
    exit 0
}

BOARD_COMMON=msm8916-common
VENDOR=samsung

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

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

# check if only a single argument was passed, and set that as the
# extraction path
if [ "x$1" != "x" ] && [ "x$2" == "x" ]; then
    SRC=$1
fi

while [ "$1" != "" ]; do
    case $1 in
        -b | --setup-all )      SETUP_DEVICE_DIR=1
                                SETUP_DEVICE_COMMON_DIR=1
                                SETUP_BOARD_COMMON_DIR=1
                                ;;
        -p | --path )           shift
                                SRC=$1
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -h | --help )           print_help
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

if  [ "$SETUP_BOARD_COMMON_DIR" -eq 1 ]; then
    # Initialize the helper for common
    setup_vendor "$BOARD_COMMON" "$VENDOR" "$LINEAGE_ROOT" true "$CLEAN_VENDOR"
    extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"
fi

if [ "$SETUP_DEVICE_COMMON_DIR" -eq 1 ] && [ -s $DEVICE_COMMON_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device-common
    setup_vendor "$DEVICE_COMMON" "$VENDOR" "$LINEAGE_ROOT" true "$CLEAN_VENDOR"
    extract $DEVICE_COMMON_DIR/proprietary-files.txt "$SRC" "$SECTION"
fi

if [ "$SETUP_DEVICE_DIR" -eq 1 ] && [ -s $DEVICE_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"
    extract $DEVICE_DIR/proprietary-files.txt "$SRC" "$SECTION"
fi

"$MY_DIR"/setup-makefiles.sh
