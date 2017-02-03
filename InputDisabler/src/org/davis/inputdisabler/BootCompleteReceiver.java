package org.davis.inputdisabler;

/*
 * Created by Dāvis Mālnieks on 04/10/2015
 */

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BootCompleteReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if(intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            // Setup the intent for the service
            Intent startIntent = new Intent();
            startIntent.setClass(context, InputDisablerService.class);

            // Start the service
            context.startService(startIntent);
        }
    }
}

