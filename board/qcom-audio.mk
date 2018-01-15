BOARD_USES_CUSTOM_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
BOARD_USES_GENERIC_AUDIO := true
TARGET_USES_QCOM_MM_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1
AUDIO_FEATURE_SAMSUNG_DUAL_SIM := true


CONFIG_PATH := hardware/qcom/audio-caf/msm8916/configs

# Audio configuration file
PRODUCT_COPY_FILES += \
    $(CONFIG_PATH)/msm8916_32/audio_policy.conf:system/etc/audio_policy.conf \
    $(CONFIG_PATH)/msm8916_32/audio_effects.conf:system/vendor/etc/audio_effects.conf

# Mixer paths
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/configs/audio/mixer_paths.xml:system/etc/mixer_paths.xml

#XML Audio configuration files
ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    $(TOPDIR)$(CONFIG_PATH)/msm8916_32/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:/system/etc/a2dp_audio_policy_configuration.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:/system/etc/audio_policy_volumes.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/default_volume_tables.xml:/system/etc/default_volume_tables.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:/system/etc/r_submix_audio_policy_configuration.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:/system/etc/usb_audio_policy_configuration.xml
endif
