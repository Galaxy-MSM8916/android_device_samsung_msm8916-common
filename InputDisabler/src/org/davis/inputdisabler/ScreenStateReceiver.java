package org.davis.inputdisabler;

/*
 * Created by Dāvis Mālnieks on 04/10/2015
 */

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.telephony.TelephonyManager;
import android.util.Log;

import java.io.FileOutputStream;
import java.io.IOException;

import org.davis.inputdisabler.Constants;

public class ScreenStateReceiver extends BroadcastReceiver implements SensorEventListener {

    public static final String TAG = "ScreenStateReceiver";

    public static final boolean DEBUG = true;

    SensorManager mSensorManager;

    Sensor mSensor;

    @Override
    public void onReceive(Context context, Intent intent) {

        if(DEBUG){
            Log.d(TAG, "Received intent");
        }
        
        switch (intent.getAction()) {
            case Intent.ACTION_SCREEN_ON:
                Log.d(TAG, "Screen on!");
                enableDevices(true);
                break;
            case Intent.ACTION_SCREEN_OFF:
                Log.d(TAG, "Screen off!");
                enableDevices(false);
                break;
            case TelephonyManager.ACTION_PHONE_STATE_CHANGED:
                Log.d(TAG, "Phone state changed!");
            
                final TelephonyManager telephonyManager =
                        (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            
                switch (telephonyManager.getCallState()) {
                    case TelephonyManager.CALL_STATE_OFFHOOK:
                        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
                        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
                        mSensorManager.registerListener(this, mSensor, 3);
                        break;
                    case TelephonyManager.CALL_STATE_IDLE:
                        if(mSensorManager != null) {
                            mSensorManager.unregisterListener(this);
                        }
                    break;
                }
            break;
        }
    }
    
    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        if(sensorEvent.values[0] == 0.0f) {
            if(DEBUG){
                Log.d(TAG, "Proximity: screen off");
            }
            enableDevices(false);
        } else {
            if(DEBUG){
                Log.d(TAG, "Proximity: screen on");
            }
            enableDevices(true);
        }
    }

    
    // Wrapper method
    private void enableDevices(boolean enable) {
        boolean ret;
        if(enable) {
            // Turn on touch input
            ret = write_sysfs(Constants.getTsPath(), true);
            if(DEBUG){
               Log.d(TAG, "Enabled touchscreen successfully? :" + ret);
            }   
        } else {
            // Turn off touch input
            ret = write_sysfs(Constants.getTsPath(), false);
            if(DEBUG){
                Log.d(TAG, "Disabled touchscreen successfully? :" + ret);
            }   
        }
    }

    // Writes to sysfs node, returns true if success, false if fail
    private boolean write_sysfs(String path, boolean on) {
        try {
            FileOutputStream fos = new FileOutputStream(path);
            byte[] bytes = new byte[2];
            bytes[0] = (byte)(on ? '1' : '0');
            bytes[1] = '\n';
            fos.write(bytes);
            fos.close();
        } catch (Exception e) {
            Log.e(TAG, "Failure: " + e.getLocalizedMessage());
            return false;
        }
        
        return true;
    }
	
	@Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }
}
