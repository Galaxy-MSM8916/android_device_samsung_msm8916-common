/*
 * Copyright (C) 2018 The LineageOS Project
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

//#define LOG_NDEBUG 0
#define LOG_TAG "libstagefright_shim"
#include <utils/Log.h>

#include <OMX_Component.h>
#include <camera/Camera.h>
#include <camera/CameraParameters.h>
#include <media/stagefright/CameraSource.h>

namespace android {

static const char PIXEL_FORMAT_YUV420SP_NV21[] = "nv21";

static int32_t getColorFormat(const char* colorFormat) {
    if (!colorFormat) {
        ALOGE("Invalid color format");
        return -1;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_YUV420P)) {
       return OMX_COLOR_FormatYUV420Planar;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_YUV422SP)) {
       return OMX_COLOR_FormatYUV422SemiPlanar;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_YUV420SP)) {
        return OMX_COLOR_FormatYUV420SemiPlanar;
    }

    if (!strcmp(colorFormat, PIXEL_FORMAT_YUV420SP_NV21)) {
        static const int OMX_SEC_COLOR_FormatNV21Linear = 0x7F000011;
        return OMX_SEC_COLOR_FormatNV21Linear;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_YUV422I)) {
        return OMX_COLOR_FormatYCbYCr;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_RGB565)) {
       return OMX_COLOR_Format16bitRGB565;
    }

    if (!strcmp(colorFormat, "OMX_TI_COLOR_FormatYUV420PackedSemiPlanar")) {
       return OMX_TI_COLOR_FormatYUV420PackedSemiPlanar;
    }

    if (!strcmp(colorFormat, CameraParameters::PIXEL_FORMAT_ANDROID_OPAQUE)) {
        return OMX_COLOR_FormatAndroidOpaque;
    }

    if (!strcmp(colorFormat, "YVU420SemiPlanar")) {
        return OMX_QCOM_COLOR_FormatYVU420SemiPlanar;
    }

    ALOGE("Uknown color format (%s), please add it to "
         "CameraSource::getColorFormat", colorFormat);

    //CHECK(!"Unknown color format");
    return -1;
}


/*
 * Check whether the camera has the supported color format
 * @param params CameraParameters to retrieve the information
 * @return OK if no error.
 */
status_t CameraSource::isCameraColorFormatSupported(
        const CameraParameters& params) {
    ALOGW("SHIM: hijacking %s!", __func__);

    mColorFormat = getColorFormat(params.get(
            CameraParameters::KEY_VIDEO_FRAME_FORMAT));
    if (mColorFormat == -1) {
        return BAD_VALUE;
    }
    return OK;
}

} // namespace android
