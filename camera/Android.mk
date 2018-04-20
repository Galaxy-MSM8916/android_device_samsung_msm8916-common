ifeq ($(TARGET_PROVIDES_CAMERA_HAL),true)
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
    system/media/camera/include \
    frameworks/native/include/media/openmax

LOCAL_SRC_FILES := \
    CameraWrapper.cpp

LOCAL_SHARED_LIBRARIES := \
    libhardware liblog libcamera_client libutils libcutils libgui libsensor

LOCAL_MODULE_RELATIVE_PATH := $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true

include $(BUILD_SHARED_LIBRARY)
endif
