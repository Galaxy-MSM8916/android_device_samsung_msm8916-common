#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

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

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for common
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true

# Warning headers and guards
write_headers "${DEVICES_ALL}"

# The standard common blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Finish
write_footers

if [ -s "${MY_DIR}/../${DEVICE_SPECIFIED_COMMON}/proprietary-files.txt" ]; then
    DEVICE_COMMON="${DEVICE_SPECIFIED_COMMON}"

    # Reinitialize the helper for device specified common
    setup_vendor "${DEVICE_SPECIFIED_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true

    # Warning headers and guards
    write_headers "${DEVICE_SPECIFIED_COMMON_DEVICE}"

    # The standard device specified common blobs
    write_makefiles "${MY_DIR}/../${DEVICE_SPECIFIED_COMMON}/proprietary-files.txt" true

    # Finish
    write_footers

    DEVICE_COMMON="msm8916-common"
fi

if [ -s "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

    # Warning headers and guards
    write_headers

    # The standard device blobs
    write_makefiles "${MY_DIR}/../${DEVICE}/proprietary-files.txt" true

    # Finish
    write_footers
fi
