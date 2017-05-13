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

# mount the system partition
mount_fs system

# Detect system sdk version
if [ -e /system/build.prop ]; then
	SDK_VERSION=`cat /system/build.prop | grep 'ro.build.version.sdk' | cut -d '=' -f 2`

    	ui_print "Checking SDK version..."
	if [ ${SDK_VERSION} -gt 25 ]; then
		ui_print "Refusing to downgrade system. Wipe data and system first or install proper package."
		exit 1
	fi
fi

#  umount system partition
umount_fs system
