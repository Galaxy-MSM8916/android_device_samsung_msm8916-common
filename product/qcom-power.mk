# Power configuration
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Power HAL
PRODUCT_PACKAGES += \
	android.hardware.power@1.0-impl \
	power.msm8916
