# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# USB HAL
PRODUCT_PACKAGES += \
	android.hardware.usb@1.0-service
