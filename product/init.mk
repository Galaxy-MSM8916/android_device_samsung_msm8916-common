# Ramdisk
PRODUCT_PACKAGES += \
	fstab.qcom \
	init.carrier.rc \
	init.qcom.ril.sh \
	init.link_ril_db.sh \
	init.qcom.usb.rc \
	init.qcom.usb.sh \
	init.qcom.rc \
	init.qcom.sh \
	init.recovery.qcom.rc \
	twrp.fstab \
	ueventd.qcom.rc

ifeq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
PRODUCT_PACKAGES += \
	init.qcom.power.rc
else
PRODUCT_PACKAGES += \
	init.qcom.post_boot.sh
endif
