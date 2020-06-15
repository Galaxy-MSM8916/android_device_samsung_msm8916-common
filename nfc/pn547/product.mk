# Inherit from common
$(call inherit-product, device/samsung/msm8916-common/nfc/common/product.mk)

# NXP NFC
PRODUCT_PACKAGES += \
    vendor.nxp.nxpnfc@1.0 \
    vendor.nxp.hardware.nfc@1.0-service

PRODUCT_PACKAGES += \
    com.gsma.services.nfc \
    com.nxp.nfc.nq \
    nfc_nci.nqx.default \
    nqnfcee_access.xml

# NXP NFC Configuration Files
PRODUCT_COPY_FILES += \
    device/samsung/msm8916-common/nfc/pn547/libnfc-nci.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/libnfc-nci.conf \
    device/samsung/msm8916-common/nfc/pn547/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    device/samsung/msm8916-common/nfc/pn547/libnfc-nxp_RF.conf:$(TARGET_COPY_OUT_VENDOR)/etc/nfc/libnfc-nxp.conf

# NXP NFC Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml
