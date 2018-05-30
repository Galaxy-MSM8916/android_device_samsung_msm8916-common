# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml
# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.4-impl \
	android.hardware.camera.provider@2.4-service \
	camera.device@3.2-impl \
	libmmcamera_interface \
	libmmjpeg_interface \
	libqomx_core \
	camera.msm8916 \
	libmm-qcamera
