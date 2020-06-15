# NFC
BOARD_NFC_HAL_SUFFIX := msm8916

# HIDL
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/nfc/common/manifest.xml

# SELinux
BOARD_SEPOLICY_DIRS += $(COMMON_PATH)/nfc/common/sepolicy
