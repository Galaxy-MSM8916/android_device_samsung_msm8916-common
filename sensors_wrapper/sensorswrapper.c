/*
 * Copyright (c) 2017 The LineageOS Project
 * Copyright (C) 2017 Martin Bouchet.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "sensors_hal_wrapper"
//#define LOG_NDEBUG 0

#include <errno.h>
#include <log/log.h>

#include <hardware/hardware.h>
#include <hardware/sensors.h>

static struct sensors_module_t *gVendorModule = 0;
static struct sensors_poll_device_1 *samsung_hw_dev = NULL;

#define WRAP_HAL(name, rettype, prototype, parameters) \
	static rettype wrapper_ ## name  prototype { \
		return samsung_hw_dev->name parameters; \
	}

static int check_vendor_module() {
	int ret = 0;

	if (gVendorModule)
		return 0;

	ret = hw_get_module_by_class("sensors", "vendor", (const hw_module_t **)&gVendorModule);
	if (ret)
		ALOGE("failed to open vendor sensors module");
	return ret;
}

int sensors_list_get(struct sensors_module_t* module, struct sensor_t const** plist) {
	if (check_vendor_module())
		return 0;
	return gVendorModule->get_sensors_list(module, plist);
}

static int wrapper_sensors_module_close(struct hw_device_t* device) {
	int ret;

	if (!device) {
		ret = -EINVAL;
	}

	ret = samsung_hw_dev->common.close(device);
	free(samsung_hw_dev);

	return ret;
}

WRAP_HAL(setDelay, int, (struct sensors_poll_device_t *dev, int handle, int64_t ns), (samsung_hw_dev, handle, ns))
WRAP_HAL(activate, int, (struct sensors_poll_device_t *dev, int handle, int enabled), (samsung_hw_dev, handle, enabled))
WRAP_HAL(poll, int, (struct sensors_poll_device_t *dev, sensors_event_t* data, int count), (samsung_hw_dev, data, count))
WRAP_HAL(flush, int, (struct sensors_poll_device_1_t *dev, int handle), (samsung_hw_dev, handle))
WRAP_HAL(batch, int, (struct sensors_poll_device_1 *dev, int handle, int flags, int64_t ns, int64_t timeout), (samsung_hw_dev, handle, flags, ns, timeout))

static int sensors_module_open(const struct hw_module_t* module, const char* id, struct hw_device_t** device) {
	int ret=0;
	struct sensors_poll_device_1 *dev;

	ALOGI("Initializing wrapper for Samsung Sensor-HAL");
	if (samsung_hw_dev) {
		ALOGE("Sensor HAL already opened!");
		ret = -ENODEV;
		goto fail;
	}
	
	ret = check_vendor_module();

	if (ret) {
		ALOGE("%s couldn't open sensors module in %s. (%s)", __func__,
				 SENSORS_HARDWARE_MODULE_ID, strerror(-ret));
		goto fail;
	}

	ret = gVendorModule->common.methods->open((const hw_module_t*)gVendorModule, id, (hw_device_t**)&samsung_hw_dev);
	
	if (ret) {
		ALOGE("%s couldn't open sensors module in %s. (%s)", __func__,
				 SENSORS_HARDWARE_MODULE_ID, strerror(-ret));
		goto fail;
	}

	*device = malloc(sizeof(struct sensors_poll_device_1));

	if (!*device) {
		ALOGE("Can't allocate memory for device, aborting...");
		ret = -ENOMEM;
		goto fail;
	}

	memset(*device, 0, sizeof(struct sensors_poll_device_1));
	dev = (struct sensors_poll_device_1*)*device;

	dev->common.tag = HARDWARE_DEVICE_TAG;
	dev->common.version = SENSORS_DEVICE_API_VERSION_1_3;
	dev->common.module = (struct hw_module_t*)module;

	dev->common.close = wrapper_sensors_module_close;
	dev->activate = wrapper_activate;
	dev->setDelay = wrapper_setDelay;
	dev->poll = wrapper_poll;
	dev->batch = wrapper_batch;
	dev->flush = wrapper_flush;

	return ret;
	
	fail:
	if (samsung_hw_dev) {
		free(samsung_hw_dev);
		samsung_hw_dev = NULL;
	}
	if (dev) {
		free(dev);
		dev = NULL;
	}
	*device = NULL;
	return ret;
}

struct hw_module_methods_t sensors_module_methods = {
	open: sensors_module_open
};

struct sensors_module_t HAL_MODULE_INFO_SYM = {
	common: {
		tag: HARDWARE_MODULE_TAG,
		version_major: 1,
		version_minor: 0,
		id: SENSORS_HARDWARE_MODULE_ID,
		name : "Samsung Sensors HAL Wrapper",
		author : "Martin Bouchet (tincho5588@gmail.com)",
		methods: &sensors_module_methods,
	},
	get_sensors_list: sensors_list_get
};
