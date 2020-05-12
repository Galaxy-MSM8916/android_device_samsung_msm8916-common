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

	if (!(file = fopen(filename, "r"))) {
		return -1;
	}

	fscanf(file, "%d", &retval);
	fclose(file);

	return retval;
}

void set_screen_dpi(const char *dpi_value)
{
	// Dynamic DPI Properties
	android::init::property_set("ro.sf.lcd_density", dpi_value);
}

void set_cdma_properties(const char *operator_alpha, const char *operator_numeric, const char * network)
{
	// Dynamic CDMA Properties
	android::init::property_set("ro.cdma.home.operator.alpha", operator_alpha);
	android::init::property_set("ro.cdma.home.operator.numeric", operator_numeric);
	android::init::property_set("ro.telephony.default_network", network);

	// Static CDMA Properties
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

void set_target_properties(const char *device, const char *model)
{
	property_override_dual("ro.product.device", "ro.product.vendor.device", device);
	property_override_dual("ro.product.model", "ro.product.vendor.model", model);

	android::init::property_set("ro.ril.telephony.mqanelements", "6");

	// Check if the simslot count file exists
	if (access(SIMSLOT_FILE, F_OK) == 0) {
		int sim_count = read_integer(SIMSLOT_FILE);

		// If it does and there are 2 SIM card slots, set dual SIM props
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
	// Set the device properties
	init_target_properties();
}

void init_target_properties(void)
{
	char *device = NULL;
	char *model = NULL;

	// Get the bootloader string
	std::string bootloader = android::base::GetProperty("ro.bootloader", "");

	// J5 2015
	if (bootloader.find("J500FN") == 0) {
		device = (char *)"j5nltexx";
		model = (char *)"SM-J500FN";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J500F") == 0) {
		device = (char *)"j5ltexx";
		model = (char *)"SM-J500F";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J500H") == 0) {
		device = (char *)"j53gxx";
		model = (char *)"SM-J500H";
		set_screen_dpi("320");
		set_gsm_properties();
	}
	else if (bootloader.find("J500M") == 0) {
		device = (char *)"j5lteub";
		model = (char *)"SM-J500M";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J500Y") == 0) {
		device = (char *)"j5ylte";
		model = (char *)"SM-J500Y";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J500G") == 0) {
		device = (char *)"j5ltedx";
		model = (char *)"SM-J500G";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J5008") == 0) {
		device = (char *)"j5ltechn";
		model = (char *)"SM-J5008";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// J5 2016
	else if (bootloader.find("J510FN") == 0) {
		device = (char *)"j5xnlte";
		model = (char *)"SM-J510FN";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J510F") == 0) {
		device = (char *)"j5xlte";
		model = (char *)"SM-J510F";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J5108") == 0) {
		device = (char *)"j5xltecmcc";
		model = (char *)"SM-J5108";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J510MN") == 0) {
		device = (char *)"j5xnlte";
		model = (char *)"SM-J510F";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J510GN") == 0) {
		device = (char *)"j5xnlte";
		model = (char *)"SM-J510F";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J510H") == 0) {
		device = (char *)"j5x3gxx";
		model = (char *)"SM-J510H";
		set_screen_dpi("320");
		set_gsm_properties();
	}
	// A3
	else if (bootloader.find("A300FU") == 0) {
		device = (char *)"a3ultexx";
		model = (char *)"SM-A300FU";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300YZ") == 0) {
		device = (char *)"a3ltezt";
		model = (char *)"SM-A300YZ";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A3000") == 0) {
		device = (char *)"a3ltechn";
		model = (char *)"SM-A3000";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A3009") == 0) {
		device = (char *)"a3ltectc";
		model = (char *)"SM-A3009";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300F") == 0) {
		device = (char *)"a3ltexx";
		model = (char *)"SM-A300F";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300H") == 0) {
		device = (char *)"a33g";
		model = (char *)"SM-A300H";
		set_gsm_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300M") == 0) {
		device = (char *)"a3lteub";
		model = (char *)"SM-A300M";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300G") == 0) {
		device = (char *)"a3ltezso";
		model = (char *)"SM-A300G";
		set_lte_properties();
		set_screen_dpi("400");
	}
	else if (bootloader.find("A300Y") == 0) {
		device = (char *)"a3ultedv";
		model = (char *)"SM-A300Y";
		set_lte_properties();
		set_screen_dpi("400");
	}
	// Grand Prime LTE
	else if (bootloader.find("G530HXX") == 0) {
		device = (char *)"fortuna3g";
		model = (char *)"SM-G530H";
		set_screen_dpi("240");
		set_gsm_properties();
	}
	else if (bootloader.find("G530HXC") == 0) {
		device = (char *)"fortunave3g";
		model = (char *)"SM-G530H";
		set_screen_dpi("240");
		set_gsm_properties();
	}
	else if (bootloader.find("G530FZ") == 0) {
		device = (char *)"grandprimelte";
		model = (char *)"SM-G530FZ";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("G530MUU") == 0) {
		device = (char *)"fortunaltezt";
		model = (char *)"SM-G530MU";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("G530MU") == 0) {
		device = (char *)"fortunalte";
		model = (char *)"SM-G530M";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("G530P") == 0) {
		device = (char *)"gprimeltespr";
		model = (char *)"SM-G530P";
		set_screen_dpi("240");
		set_cdma_properties("Chameleon", "310000", "10");
	}
	else if (bootloader.find("G530T1") == 0) {
		device = (char *)"gprimeltemtr";
		model = (char *)"SM-G530T1";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("G530T") == 0) {
		device = (char *)"gprimeltetmo";
		model = (char *)"SM-G530T";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("G530W") == 0) {
		device = (char *)"gprimeltecan";
		model = (char *)"SM-G530W";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("S920L") == 0) {
		device = (char *)"gprimeltetfnvzw";
		model = (char *)"SM-S920L";
		set_screen_dpi("240");
		set_cdma_properties("TracFone", "310000", "10");
	}
	// S4 mini VE 2015
	else if (bootloader.find("I9195I") == 0) {
		device = (char *)"serranovelte";
		model = (char *)"SM-I9195I";
		set_screen_dpi("240");
		set_lte_properties();
	}
	else if (bootloader.find("I9192I") == 0) {
		device = (char *)"serranove3g";
		model = (char *)"SM-I9192I";
		set_screen_dpi("240");
		set_gsm_properties();
	}
  // E5
	else if (bootloader.find("E500F") == 0) {
		device = (char *)"e5lte";
		model = (char *)"SM-E500F";
		set_screen_dpi("320");
		set_lte_properties();
	}
 	else if (bootloader.find("E500H") == 0) {
		device = (char *)"e53g";
		model = (char *)"SM-E500H";
		set_screen_dpi("320");
		set_gsm_properties();
	}
  // E7
 	else if (bootloader.find("E700F") == 0) {
		device = (char *)"e7lte";
		model = (char *)"SM-E700F";
		set_screen_dpi("320");
		set_lte_properties();
	}
 	else if (bootloader.find("E700H") == 0) {
		device = (char *)"e73g";
		model = (char *)"SM-E700H";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// On 7
	else if (bootloader.find("G600FY") == 0) {
		device = (char *)"o7prolte";
		model = (char *)"SM-G600FY";
		set_screen_dpi("320"); 
		set_lte_properties();
	}
	else if (bootloader.find("G6000") == 0) {
		device = (char *)"on7ltechn";
		model = (char *)"SM-G6000";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// Galaxy J7
	else if (bootloader.find("J700P") == 0) {
		device = (char *)"j7ltespr";
		model = (char *)"SM-J700P";
		set_screen_dpi("267");
		set_cdma_properties("Chameleon", "310000", "10");
	}
	else if (bootloader.find("J7008") == 0) {
		device = (char *)"j7ltechn";
		model = (char *)"SM-J7008";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// A5
	else if (bootloader.find("A500FU") == 0) {
		device = (char *)"a5ultexx";
		model = (char *)"SM-A500FU";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("A500F") == 0) {
		device = (char *)"a5lte";
		model = (char *)"SM-A500F";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("A500H") == 0) {
		device = (char *)"a53g";
		model = (char *)"SM-A500H";
		set_screen_dpi("320");
		set_gsm_properties();
	}
	else if (bootloader.find("A5000") == 0) {
		device = (char *)"a5ltechn";
		model = (char *)"SM-A5000";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("A5009") == 0) {
		device = (char *)"a5ltectc";
		model = (char *)"SM-A5009";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// Tab A/E
	else if (bootloader.find("T377P") == 0) {
		device = (char *)"gtesqltespr";
		model = (char *)"SM-T377P";
		set_screen_dpi("160");
		set_cdma_properties("Chameleon", "310000", "10");
	}
	else if (bootloader.find("T560NUU") == 0) {
		device = (char *)"gtelwifiue";
		model = (char *)"SM-T560NU";
		set_screen_dpi("160");
		set_wifi_properties();
	}
	else if (bootloader.find("T550") == 0) {
		device = (char *)"gt510wifi";
		model = (char *)"SM-T550";
		set_screen_dpi("160");
		set_wifi_properties();
	}
	else if (bootloader.find("T350") == 0) {
		device = (char *)"gt58wifi";
		model = (char *)"SM-T350";
		set_screen_dpi("160");
		set_wifi_properties();
	}
	else if (bootloader.find("T357T") == 0) {
		device = (char *)"gt58ltetmo";
		model = (char *)"SM-T357T";
		set_screen_dpi("160");
		set_gsm_properties();
	}
	// J3 2015
	else if (bootloader.find("J3109") == 0) {
		device = (char *)"j3ltectc";
		model = (char *)"SM-J3109";
		set_screen_dpi("320");
		set_lte_properties();
	}
	// J3 2016 Pro
	else if (bootloader.find("J3110") == 0) {
		device = (char *)"j3xproltechn";
		model = (char *)"SM-J3110";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else if (bootloader.find("J3119") == 0) {
		device = (char *)"j3xproltectc";
		model = (char *)"SM-J3119";
		set_screen_dpi("320");
		set_lte_properties();
	}
	else {
		return;
	}

	// Set the properties
	set_target_properties(device, model);
}
