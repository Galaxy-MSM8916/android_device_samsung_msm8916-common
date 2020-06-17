/*
 * Copyright (C) 2014 The CyanogenMod Project
 * Copyright (C) 2017 The Lineage Project
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

package org.lineageos.hardware;

import org.lineageos.internal.util.FileUtils;

/*
 * Disable capacitive keys
 *
 * This is intended for use on devices in which the capacitive keys
 * can be fully disabled for replacement with a soft navbar. You
 * really should not be using this on a device with mechanical or
 * otherwise visible-when-inactive keys
 */

public class KeyDisabler {

    private static final String ENABLED_PATH = "/sys/class/touch_key/enabled";
    private static final String CONTROL_PATH = "/sys/class/touch_key/control";
    private static final String STATUS_PATH = "/sys/class/touch_key/status";

    public static boolean isSupported() {
        return  FileUtils.isFileReadable(STATUS_PATH) &&
                "available".equals(FileUtils.readOneLine(STATUS_PATH));
    }

    public static boolean isActive() {
        return "false".equals(FileUtils.readOneLine(ENABLED_PATH));
    }

    public static boolean setActive(boolean state) {
        if (state) {
                FileUtils.writeLine(CONTROL_PATH, "manual");
                return FileUtils.writeLine(ENABLED_PATH, "false");
        } else {
                FileUtils.writeLine(CONTROL_PATH, "manual");
                FileUtils.writeLine(ENABLED_PATH, "true");
                return FileUtils.writeLine(CONTROL_PATH, "auto");
        }
    }
}
