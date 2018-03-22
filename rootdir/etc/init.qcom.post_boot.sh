#!/system/bin/sh
# Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`

function configure_memory_parameters() {
# Set Memory paremeters.
#
# Set per_process_reclaim tuning parameters
# 2GB 64-bit will have aggressive settings when compared to 1GB 32-bit
# 1GB and less will use vmpressure range 50-70, 2GB will use 10-70
# 1GB and less will use 512 pages swap size, 2GB will use 1024
#
# Set Low memory killer minfree parameters
# 32 bit all memory configurations will use 15K series
# 64 bit all memory configurations will use 18K series
#
# Set ALMK parameters (usually above the highest minfree values)
# 32 bit will have 53K & 64 bit will have 81K
#

ProductName=`getprop ro.product.name`

if [ "$ProductName" == "msm8909_512" ] || [ "$ProductName" == "msm8909w" ]; then
      echo "8192,11264,14336,17408,20480,26624" > /sys/module/lowmemorykiller/parameters/minfree
      echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
      echo 32768 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
else
    arch_type=`uname -m`
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    # Read adj series and set adj threshold for PPR and ALMK.
    # This is required since adj values change from framework to framework.
    adj_series=`cat /sys/module/lowmemorykiller/parameters/adj`
    adj_1="${adj_series#*,}"
    set_almk_ppr_adj="${adj_1%%,*}"

    # PPR and ALMK should not act on HOME adj and below.
    # Normalized ADJ for HOME is 6. Hence multiply by 6
    # ADJ score represented as INT in LMK params, actual score can be in decimal
    # Hence add 6 considering a worst case of 0.9 conversion to INT (0.9*6).
    set_almk_ppr_adj=$(((set_almk_ppr_adj * 6) + 6))
    echo $set_almk_ppr_adj > /sys/module/lowmemorykiller/parameters/adj_max_shift
    echo $set_almk_ppr_adj > /sys/module/process_reclaim/parameters/min_score_adj

    echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
    echo 70 > /sys/module/process_reclaim/parameters/pressure_max
    echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
    echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk

    if [ "$arch_type" == "aarch64" ] && [ $MemTotal -gt 1048576 ]; then
        echo 10 > /sys/module/process_reclaim/parameters/pressure_min
        echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
        echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
        echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    elif [ "$arch_type" == "aarch64" ] && [ $MemTotal -lt 1048576 ]; then
        echo 50 > /sys/module/process_reclaim/parameters/pressure_min
        echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
        echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
        echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    else
        echo 50 > /sys/module/process_reclaim/parameters/pressure_min
        echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
        echo "15360,19200,23040,26880,34415,43737" > /sys/module/lowmemorykiller/parameters/minfree
        echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    fi

fi
}

case "$target" in
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "206")
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 2 > /sys/class/net/rmnet0/queues/rx-0/rps_cpus
            ;;
            "247" | "248" | "249" | "250")
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
            ;;
            "239" | "241" | "263")
               if [ -f /sys/devices/soc0/revision ]; then
                   revision=`cat /sys/devices/soc0/revision`
               else
                   revision=`cat /sys/devices/system/soc/soc0/revision`
               fi
               echo 10 > /sys/class/net/rmnet0/queues/rx-0/rps_cpus
                if [ -f /sys/devices/soc0/platform_subtype_id ]; then
                    platform_subtype_id=`cat /sys/devices/soc0/platform_subtype_id`
                fi
                if [ -f /sys/devices/soc0/hw_platform ]; then
                    hw_platform=`cat /sys/devices/soc0/hw_platform`
                fi
                case "$soc_id" in
                    "239")
                    case "$hw_platform" in
                        "Surf")
                            case "$platform_subtype_id" in
                                "1" | "2")
                                    start hbtp
                                ;;
                            esac
                        ;;
                        "MTP")
                            case "$platform_subtype_id" in
                                "3")
                                    start hbtp
                                ;;
                            esac
                        ;;
                    esac
                    ;;
                esac
            ;;
            "268" | "269" | "270" | "271")
                echo 10 > /sys/class/net/rmnet0/queues/rx-0/rps_cpus
            ;;
             "233" | "240" | "242")
            echo 1 > /sys/devices/system/cpu/cpu1/online
            echo 1 > /sys/devices/system/cpu/cpu2/online
            echo 1 > /sys/devices/system/cpu/cpu3/online
       ;;
       esac
    ;;
esac

case "$target" in
    "msm8916")

        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        # HMP scheduler settings for 8916, 8936, 8939, 8929
        echo 3 > /proc/sys/kernel/sched_window_stats_policy
        echo 3 > /proc/sys/kernel/sched_ravg_hist_size

        # Apply governor settings for 8916
        case "$soc_id" in
            "206" | "247" | "248" | "249" | "250")

                # HMP scheduler load tracking settings
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8916
                echo 20 > /proc/sys/kernel/sched_small_task
                echo 30 > /proc/sys/kernel/sched_mostly_idle_load
                echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run

                # disable thermal core_control to update scaling_min_freq
                echo 0 > /sys/module/msm_thermal/core_control/enabled
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                echo "25000 1094400:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                echo 998400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                echo "1 200000:40 400000:50 533333:70 800000:82 998400:90 1094400:95 1209600:99" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu4/online
            ;;
        esac

        # Apply governor settings for 8936
        case "$soc_id" in
            "233" | "240" | "242")

                # HMP scheduler load tracking settings
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8936
                echo 50 > /proc/sys/kernel/sched_small_task
                echo 50 > /proc/sys/kernel/sched_mostly_idle_load
                echo 10 > /proc/sys/kernel/sched_mostly_idle_nr_run

                # disable thermal core_control to update scaling_min_freq, interactive gov
                echo 0 > /sys/module/msm_thermal/core_control/enabled
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                echo "25000 1113600:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
                echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
                echo 960000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
                echo "1 200000:40 400000:50 533333:70 800000:82 998400:90 1094400:95 1209600:99" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu4/online

                # Enable low power modes
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
                do
                    echo 40 > $gpu_bimc_io_percent
                done

            ;;
        esac

        # Apply governor settings for 8939
        case "$soc_id" in
            "239" | "241" | "263" | "268" | "269" | "270" | "271")

            if [ `cat /sys/devices/soc0/revision` != "3.0" ]; then
                # Apply 1.0 and 2.0 specific Sched & Governor settings

                # HMP scheduler load tracking settings
                echo 5 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8939, 8929
                echo 20 > /proc/sys/kernel/sched_small_task

                for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
                do
                    echo "cpufreq" > $devfreq_gov
                done

                for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
                do
                echo "bw_hwmon" > $devfreq_gov
                    for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
                    do
                        echo 20 > $cpu_io_percent
                    done
                done

                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
                do
                    echo 40 > $gpu_bimc_io_percent
               done
                # disable thermal core_control to update interactive gov settings
                echo 0 > /sys/module/msm_thermal/core_control/enabled

                # enable governor for perf cluster
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo "20000 1113600:50000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                echo 85 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                echo 1113600 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                echo "1 960000:85 1113600:90 1344000:80" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

                # enable governor for power cluster
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
                echo "25000 800000:50000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                echo 998400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                echo "1 800000:90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo 1 > /sys/devices/system/cpu/cpu5/online
                echo 1 > /sys/devices/system/cpu/cpu6/online
                echo 1 > /sys/devices/system/cpu/cpu7/online

                # Enable low power modes
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

                # HMP scheduler (big.Little cluster related) settings
                echo 75 > /proc/sys/kernel/sched_upmigrate
                echo 60 > /proc/sys/kernel/sched_downmigrate

                # cpu idle load threshold
                echo 30 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load

                # cpu idle nr run threshold
                echo 3 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_nr_run
                echo 3 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_nr_run

            else
                # Apply 3.0 specific Sched & Governor settings
                # HMP scheduler settings for 8939 V3.0
                echo 3 > /proc/sys/kernel/sched_window_stats_policy
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size
                echo 20000000 > /proc/sys/kernel/sched_ravg_window

                # HMP Task packing settings for 8939 V3.0
                echo 20 > /proc/sys/kernel/sched_small_task
                echo 30 > /proc/sys/kernel/sched_mostly_idle_load
                echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run

                echo 0 > /sys/devices/system/cpu/cpu0/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu1/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu2/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu3/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu4/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu5/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu6/sched_prefer_idle
                echo 0 > /sys/devices/system/cpu/cpu7/sched_prefer_idle

                for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
                do
                    echo "cpufreq" > $devfreq_gov
                done

                for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
                do
                    echo "bw_hwmon" > $devfreq_gov
                    for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
                    do
                        echo 20 > $cpu_io_percent
                    done
                done

                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
                do
                    echo 40 > $gpu_bimc_io_percent
                done
                # disable thermal core_control to update interactive gov settings
                echo 0 > /sys/module/msm_thermal/core_control/enabled

                # enable governor for perf cluster
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                echo "19000 1113600:39000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                echo 85 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                echo 1113600 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                echo "1 960000:85 1113600:90 1344000:80" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

                # enable governor for power cluster
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
                echo 39000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                echo "1 800000:90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

                # enable thermal core_control now
                echo 1 > /sys/module/msm_thermal/core_control/enabled

                # Bring up all cores online
                echo 1 > /sys/devices/system/cpu/cpu1/online
                echo 1 > /sys/devices/system/cpu/cpu2/online
                echo 1 > /sys/devices/system/cpu/cpu3/online
                echo 1 > /sys/devices/system/cpu/cpu5/online
                echo 1 > /sys/devices/system/cpu/cpu6/online
                echo 1 > /sys/devices/system/cpu/cpu7/online

                # Enable low power modes
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

                # HMP scheduler (big.Little cluster related) settings
                echo 93 > /proc/sys/kernel/sched_upmigrate
                echo 83 > /proc/sys/kernel/sched_downmigrate

                # Enable sched guided freq control
                echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
                echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
                echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
                echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
                echo 50000 > /proc/sys/kernel/sched_freq_inc_notify
                echo 50000 > /proc/sys/kernel/sched_freq_dec_notify

                # Enable core control
                insmod /system/lib/modules/core_ctl.ko
                echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
                echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
                echo 68 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
                echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
                echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
                case "$revision" in
                     "3.0")
                     # Enable dynamic clock gatin
                    echo 1 > /sys/module/lpm_levels/lpm_workarounds/dynamic_clock_gating
                ;;
                esac
            fi
            ;;
        esac
        # Set Memory parameters
        configure_memory_parameters
        restorecon -R /sys/devices/system/cpu
    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

# Post-setup services
case "$target" in
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case $soc_id in
            "239" | "241" | "263" | "268" | "269" | "270" | "271")
                setprop ro.min_freq_0 960000
                setprop ro.min_freq_4 800000
            ;;
            "206" | "247" | "248" | "249" | "250" | "233" | "240" | "242")
                setprop ro.min_freq_0 200000
           ;;
        esac
        #start perfd after setprop
        start perfd # start perfd on 8916, 8939 and 8929
    ;;
esac

case "$target" in
    "msm8916")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac
