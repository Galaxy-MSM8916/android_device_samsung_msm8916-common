LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := liblog libcutils libbinder libutils

LOCAL_SRC_FILES := \
    gps_shim.cpp

LOCAL_MODULE := libgps_shim
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

include $(BUILD_SHARED_LIBRARY)
