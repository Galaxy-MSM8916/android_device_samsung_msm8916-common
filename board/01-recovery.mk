# TWRP
#ifneq ($(wildcard bootable/recovery-twrp),)
#	RECOVERY_VARIANT := twrp
#endif

BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_USE_CUSTOM_RECOVERY_FONT 	    := \"roboto_23x41.h\"
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/samsung/msm8916-common/recovery/recovery_keys.c
BOARD_HAS_NO_MISC_PARTITION 		:= true
BOARD_RECOVERY_SWIPE 				:= true
BOARD_USES_MMCUTILS 				:= true
BOARD_SUPPRESS_EMMC_WIPE := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGB_565"
TARGET_RECOVERY_DENSITY 			:= hdpi
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_HAS_DOWNLOAD_MODE := true
TW_HAS_MTP := true
TW_INPUT_BLACKLIST := "accelerometer\x0ahbtp_vm"
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_MTP_DEVICE := /dev/mtp_usb
TW_NEW_ION_HEAP := true
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_USB_STORAGE := true
TW_TARGET_USES_QCOM_BSP := false
TW_THEME := portrait_hdpi
TW_EXCLUDE_SUPERSU := true
TW_INCLUDE_NTFS_3G := true

TARGET_RECOVERY_FSTAB := device/samsung/msm8916-common/recovery/recovery.fstab

ifeq ($(RECOVERY_VARIANT),twrp)
	BOARD_GLOBAL_CFLAGS += -DTW_USE_MINUI_CUSTOM_FONTS
endif
