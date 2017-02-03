package org.davis.inputdisabler;

/*
 * Created by Dāvis Mālnieks on 04/10/2015
 */

import android.app.Service;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.telephony.TelephonyManager;
import android.util.Log;

import org.davis.inputdisabler.Constants;

public class InputDisablerService extends Service {

    public static final String TAG = "InputDisablerService";

    ScreenStateReceiver mScreenStateReceiver;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Intent.ACTION_SCREEN_ON);
        intentFilter.addAction(Intent.ACTION_SCREEN_OFF);
        intentFilter.addAction(Constants.ACTION_DOZE_PULSE_STARTING);
        intentFilter.addAction(TelephonyManager.ACTION_PHONE_STATE_CHANGED);

        // Create the receiver
        mScreenStateReceiver = new ScreenStateReceiver();
        registerReceiver(mScreenStateReceiver, intentFilter);

        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        if(mScreenStateReceiver != null)
            unregisterReceiver(mScreenStateReceiver);
    }
}
