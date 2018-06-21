# Power HAL
PRODUCT_PACKAGES += \
	android.hardware.power@1.0-impl \
	android.hardware.power@1.0-service

ifneq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
PRODUCT_PACKAGES += \
	power.msm8916
endif