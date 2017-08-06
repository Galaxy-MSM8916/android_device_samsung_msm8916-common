# OTA scripts
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/releasetools/run_scripts.sh:install/bin/run_scripts.sh \
	$(LOCAL_PATH)/releasetools/functions.sh:install/bin/functions.sh \
	$(LOCAL_PATH)/releasetools/postvalidate/resize_system.sh:install/bin/postvalidate/resize_system.sh
