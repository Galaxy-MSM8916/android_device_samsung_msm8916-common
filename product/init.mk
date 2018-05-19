# Ramdisk
PRODUCT_PACKAGES += \
	fstab.qcom \
	init.carrier.rc \
	init.qcom.ril.sh \
	init.qcom.post_boot.sh \
ifeq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
	init.qcom.power.rc \
else
	init.qcom.early_boot.sh \
endif
	init.link_ril_db.sh \
	init.qcom.usb.rc \
	init.qcom.usb.sh \
	init.qcom.rc \
	init.recovery.qcom.rc \
	twrp.fstab \
	ueventd.qcom.rc
