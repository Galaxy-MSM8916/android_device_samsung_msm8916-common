# Display
PRODUCT_PACKAGES += \
	copybit.msm8916 \
	gralloc.msm8916 \
	hwcomposer.msm8916 \
	libgenlock \
	libtinyxml \
	libtinyxml2 \
	memtrack.msm8916 \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.mapper@2.0-impl \
	android.hardware.memtrack@1.0-impl

# RenderScript HAL
PRODUCT_PACKAGES += \
	android.hardware.renderscript@1.0-impl

# LiveDisplay native
PRODUCT_PACKAGES += \
	vendor.lineage.livedisplay@1.0-service-sdm

ifeq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=196608
else
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=196610
endif