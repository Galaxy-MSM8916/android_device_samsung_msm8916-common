ifeq ($(TARGET_PROVIDES_CAMERA_HAL),true)
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
    system/media/camera/include

LOCAL_SRC_FILES := \
    CameraWrapper.cpp

LOCAL_SHARED_LIBRARIES := \
    libhardware liblog libcamera_client libutils libbase libhidltransport

LOCAL_STATIC_LIBRARIES := \
	libarect

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
    frameworks/av/include

LOCAL_SRC_FILES := \
    CameraParameters.cpp \
    CameraParameters_EXT.cpp

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE := libcamera_parameters_ext
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)
