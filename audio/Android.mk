MY_LOCAL_PATH := $(call my-dir)

ifneq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
include $(MY_LOCAL_PATH)/hal/Android.mk
include $(MY_LOCAL_PATH)/policy_hal/Android.mk
endif
