LOCAL_PATH:= $(call my-dir)
#Fix InputDisabler to support all the devices to reduce duplication.
ifeq ($(BOARD_VENDOR),samsung)
ifeq ($(TARGET_BOARD_PLATFORM),msm8916)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-java-files-under, src)

LOCAL_PACKAGE_NAME := InputDisabler

LOCAL_CERTIFICATE := platform

LOCAL_PRIVILEGED_MODULE := true

include $(BUILD_PACKAGE)
endif
endif
