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

LOCAL_PATH := device/samsung/msm8916-common

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# Camera
TARGET_USE_VENDOR_CAMERA_EXT := true
TARGET_PROVIDES_CAMERA_HAL := true
USE_DEVICE_SPECIFIC_CAMERA := true

ADDITIONAL_DEFAULT_PROPERTIES += \
	camera2.portability.force_api=1

# CMHW
BOARD_USES_CYANOGEN_HARDWARE := true
BOARD_HARDWARE_CLASS :=	$(LOCAL_PATH)/cmhw
BOARD_HARDWARE_CLASS +=	\
	hardware/cyanogen/cmhw \
	hardware/samsung/cmhw

# Wifi
WLAN_CHIPSET := pronto
BOARD_HAS_QCOM_WLAN := true
BOARD_HAS_QCOM_WLAN_SDK := true
BOARD_HAVE_SAMSUNG_WIFI := true
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
WIFI_DRIVER_MODULE_PATH  := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME := "wlan"

#make, move, symlink and strip the wlan kernel module.
KERNEL_EXTERNAL_MODULES:
	+$(MAKE) -C device/samsung/msm8916-common/wlan/prima/ WLAN_ROOT=$(ANDROID_BUILD_TOP)/device/samsung/msm8916-common/wlan/prima/ \
		KERNEL_SOURCE=$(KERNEL_OUT) ARCH="arm" \
		CROSS_COMPILE="arm-eabi-"
	mkdir $(KERNEL_MODULES_OUT)/$(WLAN_CHIPSET)/ -p
	ln -sf /system/lib/modules/$(WLAN_CHIPSET)/$(WLAN_CHIPSET)_wlan.ko $(TARGET_OUT)/lib/modules/wlan.ko
	mv device/samsung/msm8916-common/wlan/prima/wlan.ko $(KERNEL_MODULES_OUT)/$(WLAN_CHIPSET)/$(WLAN_CHIPSET)_wlan.ko
	arm-eabi-strip --strip-debug $(KERNEL_MODULES_OUT)/$(WLAN_CHIPSET)/$(WLAN_CHIPSET)_wlan.ko
	+$(MAKE) -C device/samsung/msm8916-common/wlan/prima/ clean
TARGET_KERNEL_MODULES := KERNEL_EXTERNAL_MODULES
