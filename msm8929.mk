TARGET_BOARD_PLATFORM_VARIANT := msm8929

# Chipname
PRODUCT_PROPERTY_OVERRIDES += \
    ro.chipname=MSM8929

# Ramdisk
PRODUCT_PACKAGES += \
    init.target.rc

$(call inherit-product, device/samsung/msm8916-common/msm8916.mk)
