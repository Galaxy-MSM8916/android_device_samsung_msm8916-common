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

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#define SIMSLOT_FILE "/proc/simslot_count"

#include <init_msm8916.h>

__attribute__ ((weak))
void init_target_properties()
{
}

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

/* Read the file at filename and returns the integer
 * value in the file.
 *
 * @prereq: Assumes that integer is non-negative.
 *
 * @return: integer value read if succesful, -1 otherwise. */
int read_integer(const char* filename)
{
	int retval;
	FILE * file;

	/* open the file */
	if (!(file = fopen(filename, "r"))) {
		return -1;
	}
	/* read the value from the file */
	fscanf(file, "%d", &retval);
	fclose(file);

	return retval;
}

void cdma_properties(const char *operator_alpha, const char *operator_numeric)
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

void dsds_properties()
{
	property_set("ro.multisim.simslotcount", "2");
	property_set("ro.telephony.ril.config", "simactivation");
	property_set("persist.radio.multisim.config", "dsds");
	property_set("rild.libpath2", "/system/lib/libsec-ril-dsds.so");
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


void set_target_properties(const char *bootloader, const char *device, const char *model,
		int network_type, const char *operator_alpha, const char *operator_numeric)
{
	/* call set_target_properties with device specified twice for compatibility */
	set_target_properties(NULL, bootloader, device, device, model,
			network_type, operator_alpha, operator_numeric, NULL);
}

void set_target_properties(const char *bootloader, const char *name, const char *device,
		const char *model, int network_type, const char *operator_alpha,
		const char *operator_numeric)
{
	/* call set_target_properties with device specified twice for compatibility */
	set_target_properties(NULL, bootloader, name, device, model,
			network_type, operator_alpha, operator_numeric, NULL);
}


void set_target_properties(const char *ro_build_id, const char *bootloader_str, const char *name,
		const char *device, const char *model, int network_type, const char *operator_alpha,
		const char *operator_numeric, const char *ver_release)
{
 	char description[PROP_VALUE_MAX];
	char display_id[PROP_VALUE_MAX];
	char fingerprint[PROP_VALUE_MAX];

	char *bootloader = (char *)bootloader_str;
	char *build_id = (char *)ro_build_id;
	char *version_release = (char *)ver_release;

	if (bootloader_str == NULL)
		bootloader = (char *)property_get("ro.bootloader").c_str();

	if (build_id == NULL)
		build_id = (char *)property_get("ro.build.id").c_str();

	if (version_release == NULL)
		version_release = (char *)property_get("ro.build.version.release").c_str();

	/* initialise the buffers */
	memset(description, 0, PROP_VALUE_MAX);
	memset(display_id, 0, PROP_VALUE_MAX);
	memset(fingerprint, 0, PROP_VALUE_MAX);

	snprintf(description, PROP_VALUE_MAX, "%s-user %s %s %s release-keys",
			name, version_release, build_id, bootloader);
	snprintf(display_id, PROP_VALUE_MAX, "%s release-keys", build_id);
	snprintf(fingerprint, PROP_VALUE_MAX, "samsung/%s/%s:%s/%s/%s:user/release-keys",
			name, device, version_release, build_id, bootloader);

	/* set the build properties */
	property_override("ro.bootimage.build.fingerprint", fingerprint);
	property_override("ro.build.description", description);
	property_override("ro.build.display.id", display_id);
	property_override("ro.build.fingerprint", fingerprint);
	property_override("ro.build.product", device);
	property_override("ro.product.device", device);
	property_override("ro.product.model", model);

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

	/* check for multi-sim devices */

	/* check if the simslot count file exists */
	if (access(SIMSLOT_FILE, F_OK) == 0) {
		int sim_count= read_integer(SIMSLOT_FILE);

		/* set the dual sim props */
		if (sim_count == 2)
			dsds_properties();
	}
}	

void vendor_load_properties(void)
{
	/* set the device properties */
	init_target_properties();
}
