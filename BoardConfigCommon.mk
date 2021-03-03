#
# Copyright (C) 2017-2018 The LineageOS Project
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

COMMON_PATH := device/samsung/msm8916-common

# Inherit from common
-include device/samsung/qcom-common/BoardConfigCommon.mk

BUILD_BROKEN_DUP_RULES := true

# Architecture/platform
FORCE_32_BIT := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_BOARD_PLATFORM := msm8916
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Audio
AUDIO_CONFIG_PATH := hardware/qcom-caf/msm8916/audio/configs
AUDIO_FEATURE_SAMSUNG_DUAL_SIM := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := false
AUDIO_FEATURE_ENABLED_INCALL_MUSIC := true
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_GENERIC_AUDIO := true
TARGET_USES_QCOM_MM_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
USE_XML_AUDIO_POLICY_CONF := 1

# Binder API version
TARGET_USES_64_BIT_BINDER := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_BTNV := true
BLUETOOTH_HCI_USE_MCT := true

# Bootanimation
TARGET_BOOTANIMATION_HALF_RES := true

# Bootloader
BOARD_PROVIDES_BOOTLOADER_MESSAGE := false
TARGET_BOOTLOADER_BOARD_NAME := MSM8916

# Camera
BOARD_GLOBAL_CFLAGS += -DMETADATA_CAMERA_SOURCE
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_PROVIDES_CAMERA_HAL := true
TARGET_USE_VENDOR_CAMERA_EXT := true
TARGET_USES_QTI_CAMERA_DEVICE := true

# Display
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so
MAX_VIRTUAL_DISPLAY_DIMENSION := 2048
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000U
TARGET_CONTINUOUS_SPLASH_ENABLED := true
TARGET_HAVE_NEW_GRALLOC := true
SF_START_GRAPHICS_ALLOCATOR_SERVICE := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_USE_COMPAT_GRALLOC_PERFORM := true

# Encryption
TARGET_LEGACY_HW_DISK_ENCRYPTION := true
TARGET_HW_DISK_ENCRYPTION := true

# Filesystems
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE   := ext4
BOARD_SYSTEMIMAGE_PARTITION_TYPE    := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_ROOT_EXTRA_FOLDERS := firmware firmware-modem persist efs
BOARD_ROOT_EXTRA_SYMLINKS := /data/tombstones:/tombstones

# FM
AUDIO_FEATURE_ENABLED_FM := true
BOARD_HAVE_QCOM_FM := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true

# HIDL
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/compatibility_matrix.xml
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# Init
TARGET_INIT_VENDOR_LIB ?= //$(COMMON_PATH):libinit_msm8916
TARGET_RECOVERY_DEVICE_MODULES ?= libinit_msm8916

# Kernel
BOARD_KERNEL_CMDLINE += \
	console=null \
	androidboot.hardware=qcom \
	user_debug=23 \
	msm_rtb.filter=0x3F \
	ehci-hcd.park=3 \
	androidboot.bootdevice=7824900.sdhci \
	androidboot.selinux=permissive

BOARD_CUSTOM_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG_MK := hardware/samsung/mkbootimg.mk
BOARD_DTBTOOL_ARGS := -2
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_IMAGE_NAME := zImage
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_SEPARATED_DT := true
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
LZMA_RAMDISK_TARGETS := recovery
TARGET_KERNEL_CONFIG := msm8916_sec_defconfig
TARGET_KERNEL_SELINUX_CONFIG := selinux_defconfig
TARGET_KERNEL_SELINUX_LOG_CONFIG := selinux_log_defconfig
TARGET_KERNEL_SOURCE := kernel/samsung/msm8916

# Kernel - Toolchain
ifneq ($(wildcard $(BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/arm/arm-eabi-7.2/bin),)
    KERNEL_TOOLCHAIN := $(BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/arm/arm-eabi-7.2/bin
    KERNEL_TOOLCHAIN_PREFIX := arm-eabi-
endif

# Malloc implementation
MALLOC_SVELTE := true

# Media
TARGET_QCOM_MEDIA_VARIANT           := caf
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Network Routing
TARGET_NEEDS_NETD_DIRECT_CONNECT_RULE := true

# Partition sizes
BOARD_BOOTIMAGE_PARTITION_SIZE      := 13631488
BOARD_RECOVERYIMAGE_PARTITION_SIZE  := 15728640
BOARD_CACHEIMAGE_PARTITION_SIZE     := 314572800
BOARD_FLASH_BLOCK_SIZE              := 131072

# APEX image
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Legacy BLOB Support
TARGET_PROCESS_SDK_VERSION_OVERRIDE += \
    /system/bin/mediaserver=22 \
    /system/vendor/bin/mm-qcamera-daemon=22 \
    /system/vendor/bin/hw/rild=27

# Power
TARGET_USES_INTERACTION_BOOST := true

# Radio
TARGET_USES_OLD_MNC_FORMAT := true

# Qualcomm support
TARGET_USES_QCOM_BSP := true
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE   := true
USE_DEVICE_SPECIFIC_QCOM_PROPRIETARY := true

# Recovery
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT	:= "RGB_565"

# SELinux
include device/qcom/sepolicy-legacy/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(COMMON_PATH)/sepolicy/vendor

# Shims
TARGET_LD_SHIM_LIBS := \
    /vendor/lib/libmmjpeg_interface.so|libboringssl-compat.so \
    /vendor/lib/libsec-ril.so|libshim_secril.so \
    /vendor/lib/libsec-ril-dsds.so|libshim_secril.so \
    /vendor/lib/hw/camera.vendor.msm8916.so|libcamera_shim.so \
    /vendor/lib/libizat_core.so|libshim_gps.so \
    /vendor/lib/libqomx_jpegenc.so|libboringssl-compat.so \
    /vendor/lib/libgeofence.so|liblocadapterbase_shim.so

# Time services
BOARD_USES_QC_TIME_SERVICES := true

# Wifi
BOARD_HAS_QCOM_WLAN := true
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
TARGET_USES_QCOM_WCNSS_QMI := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WLAN_CHIPSET := pronto
WPA_SUPPLICANT_VERSION := VER_0_8_X
WIFI_HIDL_FEATURE_DISABLE_AP_MAC_RANDOMIZATION := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

