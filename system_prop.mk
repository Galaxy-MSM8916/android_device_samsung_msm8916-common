# Assistant
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opa.eligible_device=true

# Audio encoders
PRODUCT_PROPERTY_OVERRIDES += \
	qcom.hw.aac.encoder=true

# Audio offload
PRODUCT_PROPERTY_OVERRIDES += \
	audio.offload.buffer.size.kb=32 \
	audio.offload.gapless.enabled=true \
	audio.offload.min.duration.secs=30 \
	av.offload.enable=true \
	tunnel.audio.encode=false

# Audio voice recording
PRODUCT_PROPERTY_OVERRIDES += \
	use.voice.path.for.pcm.voip=true \
	voice.playback.conc.disabled=true \
	voice.record.conc.disabled=true \
	voice.voip.conc.disabled=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
	bluetooth.hfp.client=1 \
	qcom.bluetooth.soc=smd

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
	camera2.portability.force_api=1

# Connectivity Engine
PRODUCT_PROPERTY_OVERRIDES += \
	persist.cne.dpm=0 \
	persist.cne.feature=0 \
	persist.dpm.feature=0

# Data modules
PRODUCT_PROPERTY_OVERRIDES += \
	persist.data.netmgrd.qos.enable=false \
	ro.use_data_netmgrd=false

# Fluence
PRODUCT_PROPERTY_OVERRIDES += \
	persist.audio.fluence.speaker=true \
	persist.audio.fluence.voicecall=true \
	persist.audio.fluence.voicerec=false \
	ro.qc.sdk.audio.fluencetype=none \
	ro.qc.sdk.audio.ssr=false

# FM
PRODUCT_PROPERTY_OVERRIDES += \
	ro.fm.transmitter=false

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
	debug.composition.type=c2d \
	debug.egl.hw=1 \
	debug.sf.hw=1 \
	ro.opengles.version=196608

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
	persist.gps.qc_nlp_in_use=1 \
	persist.loc.nlp_name=com.qualcomm.location \
	ro.gps.agps_provider=1 \
	ro.pip.gated=0

# Media
PRODUCT_PROPERTY_OVERRIDES += \
	media.aac_51_output_enabled=true \
	media.stagefright.enable-aac=true \
	media.stagefright.enable-fma2dp=true \
	media.stagefright.enable-http=true \
	media.stagefright.enable-player=true \
	media.stagefright.enable-qcp=true \
	media.stagefright.enable-scan=true \
	media.stagefright.legacyencoder=true \
	media.stagefright.less-secure=true \
	media.stagefright.use-awesome=true \
	media.swhevccodectype=0 \
	mm.enable.qcom_parser=3183219 \
	mm.enable.smoothstreaming=true \
	mmp.enable.3g2=true

# Misc.
PRODUCT_PROPERTY_OVERRIDES += \
	debug.mdpcomp.logs=0 \
	dev.pm.dyn_samplingrate=1 \
	persist.debug.wfd.enable=1 \
	persist.hwc.enable_vds=1 \
	persist.hwc.mdpcomp.enable=true \
	persist.sys.storage_preload=1 \
	ro.data.large_tcp_window_size=true \
	sys.disable_ext_animation=1

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.extension_library=libqti-perfd-client.so

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
	persist.radio.add_power_save=1 \
	persist.radio.apm_sim_not_pwdn=1 \
	persist.radio.snapshot_enabled=1 \
	persist.radio.snapshot_timer=22 \
	persist.radio.lte_vrte_ltd=1 \
	persist.radio.sib16_support=1

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
	persist.rild.nitz_long_ons_0="" \
	persist.rild.nitz_long_ons_1="" \
	persist.rild.nitz_long_ons_2="" \
	persist.rild.nitz_long_ons_3="" \
	persist.rild.nitz_plmn="" \
	persist.rild.nitz_short_ons_0="" \
	persist.rild.nitz_short_ons_1="" \
	persist.rild.nitz_short_ons_2="" \
	persist.rild.nitz_short_ons_3="" \
	ril.subscription.types=NV,RUIM \
	DEVICE_PROVISIONED=1 \
	rild.libpath=/system/lib/libsec-ril.so \
	rild.libargs=-d/dev/smd0 \
	ro.multisim.set_audio_params=true \
	ro.telephony.samsung.realcall=true \
	ro.telephony.ril_class=SamsungQcomRIL

# SAMP SPCM
PRODUCT_PROPERTY_OVERRIDES += \
	sys.config.samp_spcm_enable=true \
	sys.config.spcm_db_enable=true \
	sys.config.spcm_db_launcher=true \
	sys.config.spcm_preload_enable=true

# Time services
PRODUCT_PROPERTY_OVERRIDES += \
	persist.timed.enable=true

# Video encoding
PRODUCT_PROPERTY_OVERRIDES += \
	vidc.enc.narrow.searchrange=1
