/*
   Copyright (c) 2017, The LineageOS Project

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef __INIT_MSM8916__H__
#define __INIT_MSM8916__H__

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include <android-base/properties.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

#define CDMA_DEVICE 0
#define GSM_DEVICE  1
#define LTE_DEVICE  2
#define WIFI_DEVICE 3

void init_target_properties();


void set_target_properties(const char *ro_build_id, const char *bootloader, const char *name,
		const char *device, const char *model, int network_type, const char *operator_alpha,
		const char *operator_numeric, const char *ver_release);

#endif /* __INIT_MSM8916__H__ */
