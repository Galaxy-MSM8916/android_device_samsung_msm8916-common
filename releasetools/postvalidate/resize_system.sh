#!/sbin/sh
#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FS_TYPE=$(mount | grep 'on /system' | cut -d ' ' -f 5)

DEVICE_NODE=/dev/block/bootdevice/by-name/system

# only support ext4 for now
if [ "${FS_TYPE}" == "ext4" ]; then
    umount_fs /system

    ui_print "Checking the file system on /system..."
    /sbin/e2fsck -fy ${DEVICE_NODE}
    
    ui_print "Resizing system to maximal size..."
    /sbin/resize2fs -p ${DEVICE_NODE}

    ui_print "Checking the file system on /system after resize..."
    /sbin/e2fsck -fy ${DEVICE_NODE}
fi
