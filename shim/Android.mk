LOCAL_PATH:= $(call my-dir)

#########libwvm_shim############
include $(CLEAR_VARS)

LOCAL_SRC_FILES := wvm_shim.cpp
LOCAL_SHARED_LIBRARIES := libstagefright_foundation
LOCAL_MODULE := libwvm_shim
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)
################################
