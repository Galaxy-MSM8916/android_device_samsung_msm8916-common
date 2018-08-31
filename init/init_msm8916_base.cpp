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

#include <init_msm8916_base.h>

using android::base::GetProperty;
using android::base::ReadFileToString;
using android::base::Trim;

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

/* 
 * Read the file at filename and returns the integer
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

void set_cdma_properties(const char *operator_alpha, const char *operator_numeric, const char *network)
{
	/* Dynamic CDMA Properties */
	property_override("ro.cdma.home.operator.alpha", operator_alpha);
	property_override("ro.cdma.home.operator.numeric", operator_numeric);
	property_override("ro.telephony.default_network", network);

	/* Static CDMA Properties */
	property_override("ril.subscription.types", "NV,RUIM");
	property_override("ro.telephony.default_cdma_sub", "0");
	property_override("ro.telephony.get_imsi_from_sim", "true");
	property_override("ro.telephony.ril.config", "newDriverCallU,newDialCode");
	property_override("telephony.lteOnCdmaDevice", "1");
}

void set_dsds_properties()
{
	property_override("ro.multisim.simslotcount", "2");
	property_override("ro.telephony.ril.config", "simactivation");
	property_override("persist.radio.multisim.config", "dsds");
	property_override("rild.libpath2", "/vendor/lib/libsec-ril-dsds.so");
}

void set_gsm_properties()
{
	property_override("telephony.lteOnCdmaDevice", "0");
	property_override("ro.telephony.default_network", "9");
}

void set_lte_properties()
{
	property_override("persist.radio.lte_vrte_ltd", "1");
	property_override("telephony.lteOnCdmaDevice", "0");
	property_override("telephony.lteOnGsmDevice", "1");
	property_override("ro.telephony.default_network", "10");
}

void set_wifi_properties()
{
	property_override("ro.carrier", "wifi-only");
	property_override("ro.radio.noril", "1");
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

void set_common_properties()
{
	property_override("ro.ril.telephony.mqanelements", "6");

	property_override("ro.boot.btmacaddr", "00:00:00:00:00:00");

	/* 
	 * Check for multi-sim devices
	 * check if the simslot count file exists 
	 */
	if (access(SIMSLOT_FILE, F_OK) == 0) {
		int sim_count = read_integer(SIMSLOT_FILE);
		if (sim_count == 2)
			set_dsds_properties();
	}

	/* Set serial number */
	char const *serial_number_file = SERIAL_NUMBER_FILE;
	std::string serial_number;

	if (ReadFileToString(serial_number_file, &serial_number)) {
		serial_number = Trim(serial_number);
		property_override("ro.serialno", serial_number.c_str());
	}
}

void set_target_properties(const char *device, const char *model)
{
	/* Check and/or set fingerprint */
	property_override_dual("ro.product.device", "ro.product.vendor.model", device);
	property_override_dual("ro.product.model", "ro.product.vendor.device", model);
	set_fingerprint();

	/* Set common properties */
	set_common_properties();
}
