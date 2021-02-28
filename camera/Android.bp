//
// Copyright (C) 2014 The CyanogenMod Project
// Copyright (C) 2021 The LineageOS Project
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

cc_library_shared {
    name: "camera.msm8916",
    relative_install_path: "hw",

    include_dirs: [
        "system/media/camera/include",
    ],

    srcs: ["CameraWrapper.cpp"],

    shared_libs: [
        "libcamera_client",
        "liblog",
        "libutils",
        // additional libs for original camera HAL
        "libboringssl-compat",
        "libhardware",
        "libcutils",
        "libdl",
        "android.hidl.token@1.0-utils",
        "android.hardware.graphics.bufferqueue@1.0",
        "android.hardware.graphics.bufferqueue@2.0",
    ],

    static_libs: [
        // additional libs for original camera HAL
        "libbase",
        "libarect",
    ],

    cflags: [
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wno-unused-const-variable",
        "-Wno-unused-parameter",
        "-fvisibility=hidden",
    ],

    vendor: true,
}
