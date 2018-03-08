# GPS
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/gps/flp.conf:system/etc/flp.conf \
	$(LOCAL_PATH)/configs/gps/gps.conf:system/etc/gps.conf \
	$(LOCAL_PATH)/configs/gps/izat.conf:system/etc/izat.conf \
	$(LOCAL_PATH)/configs/gps/sap.conf:system/etc/sap.conf

# GPS HAL
PRODUCT_PACKAGES += \
	gps.msm8916 \
	libshim_gps \
	android.hardware.gnss@1.0-impl

# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Location
PRODUCT_PACKAGES += \
	com.android.location.provider \
	com.android.location.provider.xml
