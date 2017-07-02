# Media configurations
ifeq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/media/media_codecs.xml:system/etc/media_codecs.xml \
	$(LOCAL_PATH)/configs/media/media_codecs_performance.xml:system/etc/media_codecs_performance.xml
else
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/media/media_codecs_8929.xml:system/etc/media_codecs.xml \
	$(LOCAL_PATH)/configs/media/media_codecs_performance_8929.xml:system/etc/media_codecs_performance.xml
endif

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/media/media_codecs_sec_primary.xml:system/etc/media_codecs_sec_primary.xml \
	$(LOCAL_PATH)/configs/media/media_codecs_sec_secondary.xml:system/etc/media_codecs_sec_secondary.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml

# Media
PRODUCT_PACKAGES += \
	libextmedia_jni \
	libdashplayer \
	libdivxdrmdecrypt \
	libdrmclearkeyplugin \
	libstagefrighthw

# OpenMAX
PRODUCT_PACKAGES += \
	libmm-omxcore \
	libOmxAacEnc \
	libOmxAmrEnc \
	libOmxCore \
	libOmxEvrcEnc \
	libOmxQcelp13Enc \
	libOmxSwVencMpeg4 \
	libOmxVdec \
	libOmxVdecHevc \
	libOmxVenc \
	libOmxVidEnc \
	libOmxVdpp
