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

# Source the functions 
. /tmp/install/bin/functions.sh

# only run if an argument was passed
if ! [ -z $1 ]; then
	SCRIPT_DIR=/tmp/install/bin/${1}

	if [ -d $SCRIPT_DIR ]; then
		# run all the scripts
		for script in `find ${SCRIPT_DIR} -type f` ; do
			. $script
		done
	fi
fi

exit 0
