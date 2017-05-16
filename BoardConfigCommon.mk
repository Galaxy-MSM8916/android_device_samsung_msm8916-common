#
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
FORCE_32_BIT := true

# Inherit from common
-include device/samsung/qcom-common/BoardConfigCommon.mk

LOCAL_PATH := device/samsung/msm8916-common

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# System prop
TARGET_SYSTEM_PROP := $(LOCAL_PATH)/system.prop

# Release Tools
TARGET_RELEASETOOLS_EXTENSIONS := $(LOCAL_PATH)/releasetools

# Platform
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_BOARD_PLATFORM := msm8916
TARGET_BOARD_PLATFORM_GPU       := qcom-adreno306
BOARD_VENDOR := samsung

# Architecture
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_CORTEX_A53 := true
TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# NFC
BOARD_NFC_HAL_SUFFIX := msm8916

# Audio
BOARD_USES_ALSA_AUDIO := true
USE_LEGACY_AUDIO_POLICY := 0
USE_CUSTOM_AUDIO_POLICY := 1
TARGET_QCOM_AUDIO_VARIANT := caf
TARGET_USES_AOSP := false

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8916
BOARD_PROVIDES_BOOTLOADER_MESSAGE := true

# Relocations
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true

# Custom RIL class
BOARD_RIL_CLASS    := ../../../$(LOCAL_PATH)/ril
TARGET_RIL_VARIANT := caf
# prevent sec-ril from building
BOARD_PROVIDES_LIBRIL := false

# Charger
BOARD_CHARGER_ENABLE_SUSPEND    := true
BOARD_CHARGER_SHOW_PERCENTAGE   := true
# BOARD_CHARGING_MODE_BOOTING_LPM := /sys/class/power_supply/battery/batt_lp_charging
# CHARGING_ENABLED_PATH           := /sys/class/power_supply/battery/batt_lp_charging

# Cpusets
ENABLE_CPUSETS := true

# Enable QCOM FM feature
AUDIO_FEATURE_ENABLED_FM := true
BOARD_HAVE_QCOM_FM := true

# Protobuf
PROTOBUF_SUPPORTED := false

# Crypto
TARGET_HW_DISK_ENCRYPTION := true
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# Display
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
OVERRIDE_RS_DRIVER := libRSDriver.so
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 2048
TARGET_CONTINUOUS_SPLASH_ENABLED := true
TARGET_HAVE_NEW_GRALLOC := true

# Encryption
TARGET_SWV8_DISK_ENCRYPTION := true

# FM
AUDIO_FEATURE_ENABLED_FM := true
TARGET_QCOM_NO_FM_FIRMWARE := true

# Healthd
BOARD_HAL_STATIC_LIBRARIES := libhealthd.qcom

# Init
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# Keymaster
TARGET_HW_KEYMASTER_V03 := true

# Time services
BOARD_USES_QC_TIME_SERVICES := true

# Vold
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
BOARD_VOLD_MAX_PARTITIONS := 67
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun%d/file

# Malloc implementation
MALLOC_SVELTE := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_BTNV := true
BLUETOOTH_HCI_USE_MCT := true

# Partition sizes
BOARD_BOOTIMAGE_PARTITION_SIZE      := 13631488
BOARD_RECOVERYIMAGE_PARTITION_SIZE  := 15728640
BOARD_CACHEIMAGE_PARTITION_SIZE     := 314572800
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE   := ext4
BOARD_SYSTEMIMAGE_PARTITION_TYPE    := ext4
BOARD_FLASH_BLOCK_SIZE              := 131072

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_CMDLINE := console=null androidboot.hardware=qcom user_debug=23 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci androidboot.selinux=enforcing
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_SEPARATED_DT := true
BOARD_DTBTOOL_ARGS := -2
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
BOARD_CUSTOM_BOOTIMG_MK := $(LOCAL_PATH)/mkbootimg.mk
TARGET_KERNEL_CONFIG := msm8916_sec_defconfig
TARGET_KERNEL_SELINUX_CONFIG := selinux_defconfig
TARGET_KERNEL_SELINUX_LOG_CONFIG := selinux_log_defconfig
TARGET_KERNEL_SOURCE := kernel/samsung/msm8916

# ART
WITH_DEXPREOPT := false
WITH_DEXPREOPT_BOOT_IMG_ONLY ?= true

# Camera
TARGET_USE_VENDOR_CAMERA_EXT := true
TARGET_PROVIDES_CAMERA_HAL := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
BOARD_GLOBAL_CFLAGS += -DMETADATA_CAMERA_SOURCE
USE_DEVICE_SPECIFIC_CAMERA := true
BOARD_USE_SAMSUNG_COLORFORMAT_NV21 := true

# CMHW
BOARD_USES_CYANOGEN_HARDWARE := true
BOARD_HARDWARE_CLASS :=	$(LOCAL_PATH)/cmhw
BOARD_HARDWARE_CLASS +=	\
	hardware/cyanogen/cmhw \
	hardware/samsung/cmhw

# GPS
#BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := msm8916
#TARGET_NO_RPC := true

# Power
TARGET_POWERHAL_VARIANT := qcom
CM_POWERHAL_EXTENSION := qcom
WITH_QC_PERF := true

# Media
TARGET_QCOM_MEDIA_VARIANT           := caf
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Qualcomm support
TARGET_USES_QCOM_BSP := true
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE   := true
USE_DEVICE_SPECIFIC_QCOM_PROPRIETARY := true
TARGET_USES_NEW_ION_API := true

# SELinux
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    device/samsung/msm8916-common/sepolicy

# Recovery
TARGET_RECOVERY_FSTAB := device/samsung/msm8916-common/recovery/recovery.fstab
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/samsung/msm8916-common/recovery/recovery_keys.c
BOARD_HAS_LARGE_FILESYSTEM			:= true
TARGET_RECOVERY_DENSITY 			:= hdpi
BOARD_HAS_NO_MISC_PARTITION 		:= true
BOARD_HAS_NO_SELECT_BUTTON 			:= true
BOARD_RECOVERY_SWIPE 				:= true
BOARD_USE_CUSTOM_RECOVERY_FONT 	    := \"roboto_23x41.h\"
BOARD_USES_MMCUTILS 				:= true
BOARD_SUPPRESS_EMMC_WIPE := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGB_565"
RECOVERY_SDCARD_ON_DATA := true

# Wifi
WLAN_CHIPSET := pronto
BOARD_HAS_QCOM_WLAN := true
BOARD_HAS_QCOM_WLAN_SDK := true
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
TARGET_USES_QCOM_WCNSS_QMI := true
TARGET_USES_WCNSS_CTRL := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WPA_SUPPLICANT_VERSION := VER_0_8_X
