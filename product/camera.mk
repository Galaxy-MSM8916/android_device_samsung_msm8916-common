# Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/mediaserver.rc:system/etc/init/mediaserver.rc

# Stagefright-shims
PRODUCT_PACKAGES += \
	libcamera_shim \
	libstagefright_shim

# Camera
PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.4-impl \
	camera.device@1.0-impl \
	libmm-qcamera \
	camera.msm8916
