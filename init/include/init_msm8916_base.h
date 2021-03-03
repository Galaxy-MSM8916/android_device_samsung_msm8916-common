/*
 * Copyright (C) 2017-2021, The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __INIT_MSM8916_BASE__H__
#define __INIT_MSM8916_BASE__H__

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include <android-base/file.h>
#include <android-base/strings.h>

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "vendor_init.h"
#include "property_service.h"

#define SIMSLOT_FILE "/proc/simslot_count"
#define SERIAL_NUMBER_FILE "/efs/FactoryApp/serial_no"

void property_override(char const prop[], char const value[]);
void property_override_dual(char const system_prop[], char const vendor_prop[], char const value[]);

int read_integer(const char* filename);

void set_cdma_properties(const char *operator_alpha, const char *operator_numeric, const char * network);

void set_dsds_properties();

void set_gsm_properties();
void set_lte_properties();
void set_wifi_properties();

void set_fingerprint();

void set_common_properties();
void set_target_properties(const char *device, const char *model);

#endif /* __INIT_MSM8916_BASE__H__ */
