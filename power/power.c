/*
 * Copyright (C) 2019 The LineageOS Project
 * Copyright (C) 2016 The CyanogenMod Project
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
#define LOG_TAG "PowerHAL"

#include <hardware/hardware.h>
#include <hardware/power.h>

#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>

#include <log/log.h>

#include "power.h"

#define CPUFREQ_PATH "/sys/devices/system/cpu/cpu0/cpufreq/"
#define INTERACTIVE_PATH "/sys/devices/system/cpu/cpufreq/interactive/"

static int boostpulse_fd = -1;

static int current_power_profile = -1;

static int sysfs_write_str(char *path, char *s)
{
    char buf[80];
    int len;
    int ret = 0;
    int fd;

    fd = open(path, O_WRONLY);
    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return -1 ;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", path, buf);
        ret = -1;
    }

    close(fd);

    return ret;
}

static int sysfs_write_int(char *path, int value)
{
    char buf[80];
    snprintf(buf, 80, "%d", value);
    return sysfs_write_str(path, buf);
}

static int is_profile_valid(int profile)
{
    return profile >= 0 && profile < PROFILE_MAX;
}

void power_init(void)
{
    ALOGI("%s", __func__);
}

static int boostpulse_open()
{
    if (boostpulse_fd < 0) {
        boostpulse_fd = open(INTERACTIVE_PATH "boostpulse", O_WRONLY);
    }

    return boostpulse_fd;
}

static void set_power_profile(int profile)
{
    if (!is_profile_valid(profile)) {
        ALOGE("%s: unknown profile: %d", __func__, profile);
        return;
    }

    if (profile == current_power_profile)
        return;

    ALOGD("%s: setting profile %d", __func__, profile);

    sysfs_write_int(INTERACTIVE_PATH "boost",
                    profiles[profile].boost);
    sysfs_write_int(INTERACTIVE_PATH "boostpulse_duration",
                    profiles[profile].boostpulse_duration);
    sysfs_write_int(INTERACTIVE_PATH "go_hispeed_load",
                    profiles[profile].go_hispeed_load);
    sysfs_write_int(INTERACTIVE_PATH "hispeed_freq",
                    profiles[profile].hispeed_freq);
    sysfs_write_int(INTERACTIVE_PATH "io_is_busy",
                    profiles[profile].io_is_busy);
    sysfs_write_int(INTERACTIVE_PATH "min_sample_time",
                    profiles[profile].min_sample_time);
    sysfs_write_int(INTERACTIVE_PATH "sampling_down_factor",
                    profiles[profile].sampling_down_factor);
    sysfs_write_str(INTERACTIVE_PATH "target_loads",
                    profiles[profile].target_loads);
    sysfs_write_int(CPUFREQ_PATH "scaling_max_freq",
                    profiles[profile].scaling_max_freq);
    sysfs_write_int(CPUFREQ_PATH "scaling_min_freq",
                    profiles[profile].scaling_min_freq);

    current_power_profile = profile;
}

void power_set_interactive(int on) 
{
    if (!is_profile_valid(current_power_profile)) {
        ALOGD("%s: no power profile selected yet, setting it to balanced", __func__);
        set_power_profile(PROFILE_BALANCED);
    }

    if (on) {
        sysfs_write_int(INTERACTIVE_PATH "hispeed_freq",
                        profiles[current_power_profile].hispeed_freq);
        sysfs_write_int(INTERACTIVE_PATH "go_hispeed_load",
                        profiles[current_power_profile].go_hispeed_load);
        sysfs_write_str(INTERACTIVE_PATH "target_loads",
                        profiles[current_power_profile].target_loads);
        sysfs_write_int(CPUFREQ_PATH "scaling_min_freq",
                        profiles[current_power_profile].scaling_min_freq);
    } else {
        sysfs_write_int(INTERACTIVE_PATH "hispeed_freq",
                        profiles[current_power_profile].hispeed_freq_off);
        sysfs_write_int(INTERACTIVE_PATH "go_hispeed_load",
                        profiles[current_power_profile].go_hispeed_load_off);
        sysfs_write_str(INTERACTIVE_PATH "target_loads",
                        profiles[current_power_profile].target_loads_off);
        sysfs_write_int(CPUFREQ_PATH "scaling_min_freq",
                        profiles[current_power_profile].scaling_min_freq_off);
    }
}

void power_hint(power_hint_t hint, void* data)
{
    if (hint == POWER_HINT_SET_PROFILE) {
        set_power_profile(*(int32_t *)data);
        return;
    }

    // Skip other hints in powersave mode
    if (current_power_profile == PROFILE_POWER_SAVE)
        return;

    switch (hint) {
    case POWER_HINT_INTERACTION:
        if (!is_profile_valid(current_power_profile)) {
            ALOGD("%s: no power profile selected yet, setting it to balanced", __func__);
            set_power_profile(PROFILE_BALANCED);
        }

        if (!profiles[current_power_profile].boostpulse_duration)
            return;

        if (boostpulse_open() >= 0) {
            int len = write(boostpulse_fd, "1", 2);
            if (len < 0) {
                ALOGE("Error writing to boostpulse: %s\n", strerror(errno));

                close(boostpulse_fd);
                boostpulse_fd = -1;
            }
        }
        break;
    case POWER_HINT_LOW_POWER:
        /* This hint is handled by the framework */
        break;
    default:
        break;
    }
}