# Inherit from vendor
$(call inherit-product, vendor/samsung/j5-common/j5-common-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay_j5
