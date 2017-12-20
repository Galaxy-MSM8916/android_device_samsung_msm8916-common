# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.4-impl-legacy \
        camera.device@1.0-impl-legacy \
	libmm-qcamera \
	camera.msm8916
