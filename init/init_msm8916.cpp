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
#include <android-base/file.h>
#include <android-base/strings.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#define SIMSLOT_FILE "/proc/simslot_count"

#include <init_msm8916.h>

using android::base::GetProperty;
using android::base::ReadFileToString;
using android::base::Trim;

#define SERIAL_NUMBER_FILE "/efs/FactoryApp/serial_no"

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[], char const vendor_prop[], char const value[])
{
    property_override(system_prop, value);
    property_override(vendor_prop, value);
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

void set_cdma_properties(const char *operator_alpha, const char *operator_numeric, const char * network)
{
	/* Dynamic CDMA Properties */
	android::init::property_set("ro.cdma.home.operator.alpha", operator_alpha);
	android::init::property_set("ro.cdma.home.operator.numeric", operator_numeric);
	android::init::property_set("ro.telephony.default_network", network);

	/* Static CDMA Properties */
	android::init::property_set("ril.subscription.types", "NV,RUIM");
	android::init::property_set("ro.telephony.default_cdma_sub", "0");
	android::init::property_set("ro.telephony.get_imsi_from_sim", "true");
	android::init::property_set("ro.telephony.ril.config", "newDriverCallU,newDialCode");
	android::init::property_set("telephony.lteOnCdmaDevice", "1");
}

void set_dsds_properties()
{
	android::init::property_set("ro.multisim.simslotcount", "2");
	android::init::property_set("ro.telephony.ril.config", "simactivation");
	android::init::property_set("persist.radio.multisim.config", "dsds");
	android::init::property_set("rild.libpath2", "/system/lib/libsec-ril-dsds.so");
}

void set_gsm_properties()
{
	android::init::property_set("telephony.lteOnCdmaDevice", "0");
	android::init::property_set("ro.telephony.default_network", "9");
}

void set_lte_properties()
{
	android::init::property_set("persist.radio.lte_vrte_ltd", "1");
	android::init::property_set("telephony.lteOnCdmaDevice", "0");
	android::init::property_set("telephony.lteOnGsmDevice", "1");
	android::init::property_set("ro.telephony.default_network", "10");
}

void set_wifi_properties()
{
	android::init::property_set("ro.carrier", "wifi-only");
	android::init::property_set("ro.radio.noril", "1");
}

void set_fingerprint()
{
	std::string fingerprint = GetProperty("ro.build.fingerprint", "");

	if ((strlen(fingerprint.c_str()) > 1) && (strlen(fingerprint.c_str()) <= PROP_VALUE_MAX))
		return;

	char new_fingerprint[PROP_VALUE_MAX+1];

	std::string build_id = GetProperty("ro.build.id","");
	std::string build_tags = GetProperty("ro.build.tags","");
	std::string build_type = GetProperty("ro.build.type","");
	std::string device = GetProperty("ro.product.device","");
	std::string incremental_version = GetProperty("ro.build.version.incremental","");
	std::string release_version = GetProperty("ro.build.version.release","");

	snprintf(new_fingerprint, PROP_VALUE_MAX, "samsung/%s/%s:%s/%s/%s:%s/%s",
		device.c_str(), device.c_str(), release_version.c_str(), build_id.c_str(),
		incremental_version.c_str(), build_type.c_str(), build_tags.c_str());

	property_override_dual("ro.build.fingerprint", "ro.boot.fingerprint", new_fingerprint);
}

void set_target_properties(const char *device, const char *model)
{
	property_override_dual("ro.product.device", "ro.product.vendor.device", device);
	property_override_dual("ro.product.model", "ro.product.vendor.model", model);

	android::init::property_set("ro.ril.telephony.mqanelements", "6");

	/* check and/or set fingerprint */
	set_fingerprint();

	/* check for multi-sim devices */

	/* check if the simslot count file exists */
	if (access(SIMSLOT_FILE, F_OK) == 0) {
		int sim_count = read_integer(SIMSLOT_FILE);

		/* set the dual sim props */
		if (sim_count == 2)
			set_dsds_properties();
	}

	char const *serial_number_file = SERIAL_NUMBER_FILE;
	std::string serial_number;

	if (ReadFileToString(serial_number_file, &serial_number)) {
        	serial_number = Trim(serial_number);
        	property_override("ro.serialno", serial_number.c_str());
	}
}

void vendor_load_properties(void)
{
	/* set the device properties */
	init_target_properties();
}

void init_target_properties(void)
{
	char *device = NULL;
	char *model = NULL;

	/* get the bootloader string */
	std::string bootloader = android::base::GetProperty("ro.bootloader", "");

	if (bootloader.find("J500FN") == 0) {
		device = (char *)"j5nltexx";
		model = (char *)"SM-J500FN";
		set_lte_properties();
	}
	else if (bootloader.find("J500F") == 0) {
		device = (char *)"j5ltexx";
		model = (char *)"SM-J500F";
		set_lte_properties();
	}
	else if (bootloader.find("J500H") == 0) {
		device = (char *)"j53gxx";
		model = (char *)"SM-J500H";
		set_gsm_properties();
	}
	else if (bootloader.find("J500M") == 0) {
		device = (char *)"j5lteub";
		model = (char *)"SM-J500M";
		set_lte_properties();
	}
	else if (bootloader.find("J500Y") == 0) {
		device = (char *)"j5ylte";
		model = (char *)"SM-J500Y";
		set_lte_properties();
	}
	else if (bootloader.find("J500G") == 0) {
		device = (char *)"j5ltedx";
		model = (char *)"SM-J500G";
		set_lte_properties();
	}
	else if (bootloader.find("J5008") == 0) {
		device = (char *)"j5ltechn";
		model = (char *)"SM-J5008";
		set_lte_properties();
	}
	else if (bootloader.find("J510FN") == 0) {
        device = (char *)"j5xnlte";
        model = (char *)"SM-J510FN";
        set_lte_properties();
	}
	else if (bootloader.find("J510F") == 0) {
		device = (char *)"j5xlte";
		model = (char *)"SM-J510F";
		set_lte_properties();
	}
	else if (bootloader.find("J510MN") == 0) {
		device = (char *)"j5xnlte";
		model = (char *)"SM-J510F";
		set_lte_properties();
	}
	else if (bootloader.find("J510GN") == 0) {
		device = (char *)"j5xnlte";
		model = (char *)"SM-J510F";
		set_lte_properties();
	}
	else {
		return;
	}

	/* set the properties */
	set_target_properties(device, model);
}
