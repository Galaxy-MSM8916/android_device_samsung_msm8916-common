# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

# Stagefright-shims
PRODUCT_PACKAGES += \
	libcamera_shim

# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.4-impl \
	camera.device@1.0-impl \
	libmm-qcamera \
	camera.msm8916
