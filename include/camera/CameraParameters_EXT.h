/*
 * Copyright (c) 2017, The LineageOS Project
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

#ifndef ANDROID_HARDWARE_CAMERA_PARAMETERS_EXT_H
#define ANDROID_HARDWARE_CAMERA_PARAMETERS_EXT_H

#include <utils/KeyedVector.h>

namespace android {

class CameraParameters;
struct Size;

class CameraParameters_EXT
{
public:
    CameraParameters_EXT();
    CameraParameters_EXT(CameraParameters *p);
    ~CameraParameters_EXT();

    int get_from_attr(const char *path, char *buf, size_t len);
    bool check_flashlight_restriction();
    int lookupAttr(/* CameraParameters_EXT::CameraMap const* */
            void *cameraMap, int a3, const char *a4);

    const char *getPreviewFrameRateMode() const;
    void setPreviewFrameRateMode(const char *mode);

    void setBrightnessLumaTargetSet(int brightness, int luma);
    int getBrightnessLumaTargetSet(int *brightness, int *luma) const;

    void setTouchIndexAec(int x, int y);
    void getTouchIndexAec(int *x, int *y);

    void setTouchIndexAf(int x, int y);
    void getTouchIndexAf(int *x, int *y);

    void setZsl(const char *mode);
    const char *getZsl() const;

    void setRawSize(int x, int y);
    void getRawSize(int *x, int *y);

    void getMeteringAreaCenter(int *x, int *y) const;
    void getSupportedHfrSizes(Vector<Size> &sizes) const;
    void setPreviewFpsRange(int min, int max);
    int getOrientation() const;
    void setOrientation(int orientation);

private:
    CameraParameters *mParams;
};

}

#endif

