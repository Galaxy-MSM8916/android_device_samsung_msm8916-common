# Bluetooth
PRODUCT_PACKAGES += \
	android.hardware.bluetooth@1.0-impl

# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# Bluetooth
PRODUCT_PACKAGES += \
	javax.btobex \
	libbt-vendor
