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
import android.media.AudioManager;
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

    AudioManager mAudioManager;

    public SamsungQcomRIL(Context context, int networkMode, int cdmaSubscription) {
        this(context, networkMode, cdmaSubscription, null);
    }

    public SamsungQcomRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
        

        Rlog.e(RILJ_LOG_TAG, "Setting mAudioManager..");
        mAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
    }

    /* Toggles the loud speaker state.
     * This is a hack to get in-call sound working.
     */
    private void toggleSpeaker() {
        if (mAudioManager.isSpeakerphoneOn()) {
            Rlog.e(RILJ_LOG_TAG, "Speaker is on. Setting to: off");
            mAudioManager.setSpeakerphoneOn(false);
        }
        else {
            Rlog.e(RILJ_LOG_TAG, "Speaker is off. Setting to: on");
            mAudioManager.setSpeakerphoneOn(true);
        }
    }

    /*
     * Samsung-specific modification to enable call audio routing.
     */
    private void setRealCall(boolean value) {
        if (value) {
            Rlog.e(RILJ_LOG_TAG, "Setting realcall param to: on");
            mAudioManager.setParameters("realcall=on");
	    /* toggle speaker twice */
            toggleSpeaker();
            toggleSpeaker();
        }
        else {
            Rlog.e(RILJ_LOG_TAG, "Setting realcall param to: off");
            mAudioManager.setParameters("realcall=off");
        }
    }

    @Override
    public void
    dial(String address, int clirMode, UUSInfo uusInfo, Message result) {
        super.dial(address, clirMode, uusInfo, result);
        setRealCall(true);
    }

    @Override
    public void
    acceptCall(Message result) {
        super.acceptCall(result);
        setRealCall(true);
    }

    @Override
    public void
    hangupConnection (int gsmIndex, Message result) {
           super.hangupConnection(gsmIndex, result);
           setRealCall(false);
    }


    @Override
    public void
    hangupForegroundResumeBackground (Message result) {
            super.hangupForegroundResumeBackground(result);
            setRealCall(true);
    }


    @Override
    public void
    switchWaitingOrHoldingAndActive (Message result) {
            super.switchWaitingOrHoldingAndActive(result);
            setRealCall(true);
    }

    @Override
    public void
    rejectCall (Message result) {
            super.rejectCall(result);
            setRealCall(false);
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
