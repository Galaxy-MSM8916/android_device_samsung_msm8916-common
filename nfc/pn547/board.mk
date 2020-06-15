LOCAL_PATH := $(call my-dir)

# Inherit from common
-include device/samsung/msm8916-common/nfc/common/board.mk

# HIDL
DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/manifest.xml
