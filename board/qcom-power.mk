ifneq ($(filter j7ltespr j7ltechn,$(TARGET_DEVICE)),)
# Power
TARGET_POWERHAL_VARIANT := qcom
WITH_QC_PERF := true
endif
