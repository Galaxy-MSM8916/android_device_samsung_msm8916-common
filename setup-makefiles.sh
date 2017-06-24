#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

INITIAL_COPYRIGHT_YEAR=2017

BOARD_COMMON=msm8916-common
DEVICES_ALL="gprimelte gprimeltespr gprimeltexx gtelwifiue gtesqltespr"
VENDOR=samsung

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

CM_ROOT="$MY_DIR"/../../..
DEVICE_DIR="$MY_DIR"/../$DEVICE
DEVICE_COMMON_DIR="$MY_DIR"/../$DEVICE_COMMON

HELPER="$CM_ROOT"/vendor/cm/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ -z "$CLEANUP" ]; then
	CLEANUP=false

	if [ -n "$1" ]; then
		CLEANUP=$1
	fi
fi

if [ -n "$DEVICE_COMMON" ] && [ -s $DEVICE_COMMON_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    COMMON=1 setup_vendor "$DEVICE_COMMON" "$VENDOR" "$CM_ROOT" "false" "$CLEANUP"

    # Copyright headers and guards
    COMMON=1 write_headers "$DEVICES"

    # The standard device blobs
    write_makefiles $DEVICE_COMMON_DIR/proprietary-files.txt

    # We are done!
    write_footers
fi

if [ -n "$DEVICE" ] && [ -s $DEVICE_DIR/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$CM_ROOT" "false" "$CLEANUP"

    # Copyright headers and guards
    write_headers

    # The standard device blobs
    write_makefiles $DEVICE_DIR/proprietary-files.txt

    # We are done!
    write_footers
fi

DEVICE_COMMON=$BOARD_COMMON

# Initialize the helper for common
COMMON=1 setup_vendor "$BOARD_COMMON" "$VENDOR" "$CM_ROOT" "true" "$CLEANUP"

# Copyright headers and guards
COMMON=1 write_headers "$DEVICES_ALL"

# The standard common blobs
write_makefiles "$MY_DIR"/proprietary-files.txt

# We are done!
write_footers
