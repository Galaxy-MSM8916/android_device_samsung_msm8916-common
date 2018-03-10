#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PLATFORM_PATH := device/samsung/msm8916-common

# Includes
TARGET_SPECIFIC_HEADER_PATH := $(PLATFORM_PATH)/include

# Inherit from common
-include device/samsung/qcom-common/BoardConfigCommon.mk

# Include board config fragments
include $(PLATFORM_PATH)/board/*.mk
