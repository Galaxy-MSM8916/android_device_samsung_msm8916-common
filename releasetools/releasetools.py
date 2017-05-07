# Copyright (C) 2009 The Android Open Source Project
# Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
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

import common
import re
import os

"""Custom OTA commands for msm8916 devices"""

def FullOTA_InstallBegin(info):
    # we need to extract the install dir here because it will not have been extracted yet
    info.script.AppendExtra('package_extract_dir("install/bin", "/tmp/install/bin");')
    info.script.AppendExtra('set_metadata_recursive("/tmp/install/bin", "uid", 0, "gid", 0, "dmode", 0755, "fmode", 0755);')
    # run installbegin scripts.
    info.script.AppendExtra('assert(run_program("/tmp/install/bin/run_scripts.sh", "installbegin") == 0);')

def FullOTA_InstallEnd(info):
    # run installend scripts
    info.script.AppendExtra('assert(run_program("/tmp/install/bin/run_scripts.sh", "installend") == 0);')

def FullOTA_PostValidate(info):
    # run postvalidate scripts
    info.script.AppendExtra('assert(run_program("/tmp/install/bin/run_scripts.sh", "postvalidate") == 0);')
