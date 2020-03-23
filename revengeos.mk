# Release name
PRODUCT_RELEASE_NAME := Samsung Galaxy J5

# Boot animation
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280
TARGET_BOOT_ANIMATION_RES := 720

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/revengeos/config/common.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

## Device identifier. This must come after all inclusions
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
PRODUCT_GMS_CLIENTID_BASE := android-samsung
