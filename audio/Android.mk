MY_LOCAL_PATH := $(call my-dir)

ifneq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
include $(MY_LOCAL_PATH)/hal/Android.mk
endif
