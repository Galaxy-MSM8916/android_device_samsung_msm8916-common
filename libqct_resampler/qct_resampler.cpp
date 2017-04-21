/**
 * QCT Resampler Wrapper
 *
 * Copyright (C) 2017 Vincent Zvikaramba <vincent.zvikaramba@mail.utoronto.ca>
 *
 * liqct_resampler_wrapper is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This source is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the source code.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string>
#include <sys/types.h>
#include <dlfcn.h>
#include "QCT_Resampler.h"

#define LOG_TAG "QCT_Resampler_Wrapper"
#include <cutils/log.h>

#ifndef ALOGE
	#define ALOGE LOGE
#endif

#ifndef ALOGD
	#define ALOGD LOGD
#endif

namespace android {

#define LIBQCT_RESAMPLER "libqct_resampler.qcom.so"
#define LIBQCT_RESAMPLER_FULL "/system/vendor/lib/libqct_resampler.qcom.so"

/* function pointer declarations using function signatures from libqct_resampler */
typedef size_t (*MemAlloc_t)(int bitDepth, int inChannelCount, int32_t inSampleRate, int32_t sampleRate);
typedef void (*Init_t)(int16_t *pState, int32_t inChannelCount, int32_t inSampleRate, int32_t mSampleRate);
typedef void (*Resample90dB_t)(int16_t* pState, int16_t* in, int32_t* out, size_t inFrameCount, size_t outFrameCount);
typedef size_t (*GetNumInSamp_t)(int16_t* pState, size_t outFrameCount);

/*library handle */
int open_handle(void);
void *qct_handle = NULL;
/* declare global function ptrs */
MemAlloc_t qct_memAlloc = NULL;
Init_t qct_init = NULL;
Resample90dB_t qct_resample90dB = NULL;
GetNumInSamp_t qct_getNumInSamp = NULL;

/* Called to open the handle */
int open_handle() {
	/* try opening the library */	
	if (!qct_handle) {
		qct_handle = dlopen(LIBQCT_RESAMPLER, RTLD_LAZY);
		if (!qct_handle) {
		/* try opening the library using the full path */
		if (!(qct_handle = dlopen(LIBQCT_RESAMPLER_FULL, RTLD_LAZY))) {
			ALOGE("%s\n", dlerror());
			return 1;
			}
		}
		ALOGD("libqct_resampler opened successfully.\n");
	}
	else { /* library was opened already */
		ALOGD("libqct_resampler opened successfully.\n");
		return 0;
	}

	/* fill the function pointers using the symbol names from the library */
	MemAlloc_t qct_memAlloc = (MemAlloc_t) dlsym(qct_handle, "android::QCT_Resampler::MemAlloc");
	Init_t qct_init = (Init_t) dlsym(qct_handle, "android::QCT_Resampler::Init");
	Resample90dB_t qct_resample90dB = (Resample90dB_t) dlsym(qct_handle, "android::QCT_Resampler::Resample90dB");
	GetNumInSamp_t qct_getNumInSamp = (GetNumInSamp_t) dlsym(qct_handle, "android::QCT_Resampler::GetNumInSamp");

	/* check if all the function pointers are valid */
	if (!qct_memAlloc || !qct_init || !qct_resample90dB || !qct_getNumInSamp)  {
		ALOGE("%s\n", dlerror());
		return 1;
	}
	ALOGD("libqct_resampler symbols found and assigned.\n");
	return 0;
}

size_t QCT_Resampler::MemAlloc(int bitDepth, int inChannelCount, int32_t inSampleRate, int32_t sampleRate) {

 	/* try to open the file handle */
	if (open_handle()) return EXIT_FAILURE;
	
	return qct_memAlloc(bitDepth, inChannelCount, inSampleRate, sampleRate);
}

void QCT_Resampler::Init(int16_t *pState, int32_t inChannelCount, int32_t inSampleRate, int32_t mSampleRate, int32_t in) {

	/* try to open the file handle */
	if (open_handle()) return;

	/* call the function */
	ALOGD("discarded last function call parameter %d in QCT_Resampler::Init.\n", in);
	qct_init(pState, inChannelCount, inSampleRate, mSampleRate);
}

void QCT_Resampler::Resample90dB(int16_t* pState, int32_t* in, int32_t* out, size_t inFrameCount, size_t outFrameCount) {

	/* try to open the file handle */
	if (open_handle()) return;

	/* call the function */
	qct_resample90dB(pState, (int16_t*) in, out, inFrameCount, outFrameCount);
}

size_t QCT_Resampler::GetNumInSamp(int16_t* pState, size_t outFrameCount) {

 	/* try to open the file handle */
	if (open_handle()) return EXIT_FAILURE;

	return qct_getNumInSamp(pState, outFrameCount);
}

}
