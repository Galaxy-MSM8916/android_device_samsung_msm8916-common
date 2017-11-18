/*
 * Copyright (c) 2014-2016, The CyanogenMod Project. All rights reserved.
 * Copyright (c) 2017, The LineageOS Project. All rights reserved.
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

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.telephony.Rlog;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.os.SystemProperties;
import android.telephony.PhoneNumberUtils;
import android.telephony.SignalStrength;

import com.android.internal.telephony.cdma.CdmaInformationRecords;
import com.android.internal.telephony.cdma.CdmaInformationRecords.CdmaSignalInfoRec;
import com.android.internal.telephony.cdma.SignalToneUtil;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccUtils;
import java.util.ArrayList;
import java.util.Collections;

import android.hardware.radio.V1_0.IRadio;
import android.hardware.radio.V1_0.Dial;
import android.hardware.radio.V1_0.UusInfo;
import android.os.RemoteException;

/**
 * RIL customization for MSM8916 devices
 *
 * {@hide}
 */
public class SamsungQcomRIL extends RIL {

    public SamsungQcomRIL(Context context, int networkMode, int cdmaSubscription) {
        this(context, networkMode, cdmaSubscription, null);
    }

    public SamsungQcomRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
    }

    @Override
    protected void notifyRegistrantsCdmaInfoRec(CdmaInformationRecords infoRec) {
        final int response = RIL_UNSOL_CDMA_INFO_REC;

        if (infoRec.record instanceof CdmaSignalInfoRec) {
            CdmaSignalInfoRec rec = (CdmaSignalInfoRec) infoRec.record;
            if (rec != null
                    && rec.isPresent
                    && rec.signalType == SignalToneUtil.IS95_CONST_IR_SIGNAL_IS54B
                    && rec.alertPitch == SignalToneUtil.IS95_CONST_IR_ALERT_MED
                    && rec.signal == SignalToneUtil.IS95_CONST_IR_SIG_IS54B_L) {
                /* Drop record, otherwise IS95_CONST_IR_SIG_IS54B_L tone will
                 * continue to play after the call is connected */
                return;
            }
        }
        super.notifyRegistrantsCdmaInfoRec(infoRec);
    }

}