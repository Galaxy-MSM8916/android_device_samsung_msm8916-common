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

#include <init_msm8916.h>

#define VERSION_RELEASE "7.1.2"
#define BUILD_ID	"N2G47O"

__attribute__ ((weak))
void init_target_properties()
{
}

void cdma_properties(char *operator_alpha,
		char *operator_numeric)
{
	/* Dynamic CDMA Properties */
	property_set("ro.cdma.home.operator.alpha", operator_alpha);
	property_set("ro.cdma.home.operator.numeric", operator_numeric);
	property_set("ro.telephony.default_network", "10");

	/* Static CDMA Properties */
	property_set("ril.subscription.types", "NV,RUIM");
	property_set("ro.telephony.default_cdma_sub", "0");
	property_set("ro.telephony.get_imsi_from_sim", "true");
	property_set("ro.telephony.ril.config", "newDriverCallU,newDialCode");
	property_set("telephony.lteOnCdmaDevice", "1");
}

void gsm_properties()
{
	property_set("telephony.lteOnCdmaDevice", "0");
	property_set("ro.telephony.default_network", "9");
}

void lte_properties()
{
	property_set("persist.radio.lte_vrte_ltd", "1");
	property_set("telephony.lteOnCdmaDevice", "0");
	property_set("telephony.lteOnGsmDevice", "1");
	property_set("ro.telephony.default_network", "10");
}

void wifi_properties()
{
	property_set("ro.carrier", "wifi-only");
	property_set("ro.radio.noril", "1");
}

void set_target_properties(char *bootloader, char *device, char *model,
		int network_type, char *operator_alpha, char *operator_numeric)
{
	char description[PROP_VALUE_MAX];
	char display_id[PROP_VALUE_MAX];
	char fingerprint[PROP_VALUE_MAX];

	/* initialise the buffers */
	memset(description, 0, PROP_VALUE_MAX);
	memset(display_id, 0, PROP_VALUE_MAX);
	memset(fingerprint, 0, PROP_VALUE_MAX);

	snprintf(description, PROP_VALUE_MAX, "%s-user %s %s %s release-keys",
			device, VERSION_RELEASE, BUILD_ID, bootloader);
	snprintf(display_id, PROP_VALUE_MAX, "%s release-keys", BUILD_ID);
	snprintf(fingerprint, PROP_VALUE_MAX, "samsung/%s/%s:%s/%s/%s:user/release-keys",
			device, device, VERSION_RELEASE, BUILD_ID, bootloader);

	/* set the build properties */
	property_set("ro.build.description", description);
	property_set("ro.build.display.id", display_id);
	property_set("ro.build.fingerprint", fingerprint);
	property_set("ro.build.product", device);
	property_set("ro.product.device", device);
	property_set("ro.product.model", model);

	/* set the network properties */
	if (network_type == CDMA_DEVICE) {
		cdma_properties(operator_alpha, operator_numeric);
	}
	else if (network_type == GSM_DEVICE) {
		gsm_properties();
	}
	else if (network_type == LTE_DEVICE) {
		lte_properties();
	}
	else if (network_type == WIFI_DEVICE) {
		wifi_properties();
	}
}	

void vendor_load_properties(void)
{
	/* set the device properties */
	init_target_properties();
}
