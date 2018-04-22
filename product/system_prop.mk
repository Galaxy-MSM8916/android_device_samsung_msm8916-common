# Assistant
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opa.eligible_device=true

# Audio encoders
PRODUCT_PROPERTY_OVERRIDES += \
	qcom.hw.aac.encoder=false

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

# ZRAM
PRODUCT_PROPERTY_OVERRIDES += \
        ro.config.zram=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
	bluetooth.hfp.client=1 \
	qcom.bluetooth.soc=smd

#split  a2dp
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.bt.enable.splita2dp=false

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
	camera.disable_treble=true

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
        debug.hwui.use_buffer_age=false

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
	persist.gps.qc_nlp_in_use=1 \
	persist.loc.nlp_name=com.qualcomm.location \
	ro.gps.agps_provider=1 \
	ro.pip.gated=0

# Media
PRODUCT_PROPERTY_OVERRIDES += \
	persist.media.treble_omx=false \
	media.aac_51_output_enabled=true \
	media.stagefright.enable-aac=true \
	media.stagefright.enable-fma2dp=true \
	media.stagefright.enable-http=true \
	media.stagefright.enable-player=true \
	media.stagefright.enable-qcp=true \
	media.stagefright.enable-scan=true \
	media.stagefright.use-awesome=true \
	media.swhevccodectype=0 \
	mm.enable.qcom_parser=3183219 \
	mm.enable.smoothstreaming=true \
	mmp.enable.3g2=true

# Misc.
PRODUCT_PROPERTY_OVERRIDES += \
	debug.mdpcomp.logs=0 \
	dev.pm.dyn_samplingrate=1 \
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
	ro.multisim.set_audio_params=true

# SAMP SPCM
PRODUCT_PROPERTY_OVERRIDES += \
	sys.config.samp_spcm_enable=true \
	sys.config.spcm_db_enable=true \
	sys.config.spcm_db_launcher=true \
	sys.config.spcm_preload_enable=true

# Time services
PRODUCT_PROPERTY_OVERRIDES += \
	persist.timed.enable=true

# Updater
PRODUCT_PROPERTY_OVERRIDES += \
	lineage.updater.uri=https://ota15.msm8916.com/api

# Video encoding
PRODUCT_PROPERTY_OVERRIDES += \
	vidc.enc.narrow.searchrange=1

# WiDi
PRODUCT_PROPERTY_OVERRIDES += \
	persist.debug.wfd.enable=1 \
	persist.sys.wfd.virtual=0
