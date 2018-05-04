AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_NEW_SAMPLE_RATE := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1
AUDIO_FEATURE_SAMSUNG_DUAL_SIM := true

CONFIG_PATH := hardware/qcom/audio-caf/msm8916/configs

# Audio configuration file
PRODUCT_COPY_FILES += \
    $(CONFIG_PATH)/msm8916_32/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    $(CONFIG_PATH)/msm8916_32/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf

# Mixer paths
ifneq ($(USE_QCOM_MIXER_PATHS), false)
PRODUCT_COPY_FILES += \
    $(PLATFORM_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
endif
