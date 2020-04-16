# Inherit from vendor
$(call inherit-product, vendor/samsung/j5x-common/j5x-common-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-j5x
