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
#include <sys/stat.h>

#include <log/log.h>

#include "power.h"
#include "power_msm8916.h"
#include "power_msm8939.h"

#define CPU_PRESENCE_PATH "/sys/devices/system/cpu/present"
#define CPUFREQ_PATH "/sys/devices/system/cpu/cpu0/cpufreq/"

const char *INTERACTIVE_PATH_8916 = "/sys/devices/system/cpu/cpufreq/interactive/";
const char *INTERACTIVE_PATH_8939 = "/sys/devices/system/cpu/cpu0/cpufreq/interactive/";

enum CPUType
{
    CPU_UNKNOWN,
    CPU_MSM8916,
    CPU_MSM8939
};

static enum CPUType cpu_type = CPU_UNKNOWN;

static int boostpulse_fd = -1;

static int current_power_profile = -1;

static int sysfs_write_str(const char *path, const char *s)
{
    char buf[128];
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

static int sysfs_write_int(const char *prefix, const char *suffix, int value)
{
    char path[128];
    char buf[16];
    snprintf(path, sizeof(path), "%s%s", prefix, suffix);
    snprintf(buf, sizeof(buf), "%d", value);
    return sysfs_write_str(path, buf);
}

static bool is_msm8939(void)
{
    if (cpu_type == CPU_UNKNOWN) {
        char cpus_present[16];
        FILE *present = fopen(CPU_PRESENCE_PATH, "rb");
        if (present == NULL) // should never happen
            return false;
        fgets(cpus_present, sizeof(cpus_present), present);
        fclose(present);
        if (strcmp(cpus_present, "0-7\n") == 0) {
            ALOGD("Detected MSM8939");
            cpu_type = CPU_MSM8939;
        } else {
            ALOGD("Detected MSM8916");
            cpu_type = CPU_MSM8916;
        }
    }
    return cpu_type == CPU_MSM8939;
}

static const char *get_interactive_path(void)
{
    if (is_msm8939())
        return INTERACTIVE_PATH_8939;
    else
        return INTERACTIVE_PATH_8916;
}

static const power_profile *get_profiles(void)
{
    if (is_msm8939())
        return profiles_8939;
    else
        return profiles_8916;
}

static bool check_governor(void)
{
    const char *interactive_path = get_interactive_path();
    struct stat s;
    int err = stat(interactive_path, &s);
    if (err != 0) return false;
    if (S_ISDIR(s.st_mode)) return true;
    return false;
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
        const char *interactive_path = get_interactive_path();
        char bp_path[128];
        strcpy(bp_path, interactive_path);
        strcat(bp_path, "boostpulse");
        boostpulse_fd = open(bp_path, O_WRONLY);
    }

    return boostpulse_fd;
}

void power_set_interactive(int on)
{
    const char *interactive_path = get_interactive_path();
    const power_profile *profiles = get_profiles();

    if (!is_profile_valid(current_power_profile)) {
        ALOGD("%s: no power profile selected yet", __func__);
        return;
    }

    // break out early if governor is not interactive
    if (!check_governor()) return;

    if (on) {
        sysfs_write_int(interactive_path, "hispeed_freq",
                        profiles[current_power_profile].hispeed_freq);
        sysfs_write_int(interactive_path, "go_hispeed_load",
                        profiles[current_power_profile].go_hispeed_load);
        sysfs_write_int(interactive_path, "target_loads",
                        profiles[current_power_profile].target_loads);
        sysfs_write_int(CPUFREQ_PATH, "scaling_min_freq",
                        profiles[current_power_profile].scaling_min_freq);
    } else {
        sysfs_write_int(interactive_path, "hispeed_freq",
                        profiles[current_power_profile].hispeed_freq_off);
        sysfs_write_int(interactive_path, "go_hispeed_load",
                        profiles[current_power_profile].go_hispeed_load_off);
        sysfs_write_int(interactive_path, "target_loads",
                        profiles[current_power_profile].target_loads_off);
        sysfs_write_int(CPUFREQ_PATH, "scaling_min_freq",
                        profiles[current_power_profile].scaling_min_freq_off);
    }
}

void power_hint(power_hint_t hint)
{
    const power_profile *profiles = get_profiles();
    char buf[80];
    int len;

    // Skip other hints in powersave mode
    if (current_power_profile == PROFILE_POWER_SAVE)
        return;

    switch (hint) {
    case POWER_HINT_INTERACTION:
        if (!is_profile_valid(current_power_profile)) {
            ALOGD("%s: no power profile selected yet", __func__);
            return;
        }

        if (!profiles[current_power_profile].boostpulse_duration)
            return;

        if (boostpulse_open() >= 0) {
            snprintf(buf, sizeof(buf), "%d", 1);
            len = write(boostpulse_fd, &buf, sizeof(buf));
            if (len < 0) {
                strerror_r(errno, buf, sizeof(buf));
                ALOGE("Error writing to boostpulse: %s\n", buf);

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
