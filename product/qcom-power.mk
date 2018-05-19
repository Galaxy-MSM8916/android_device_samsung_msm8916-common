# Power configuration
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Power HAL
PRODUCT_PACKAGES += \
	power.msm8916
