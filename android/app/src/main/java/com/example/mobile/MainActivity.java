package com.example.mobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        onNewIntent(getIntent());
    }

    @Override
    protected  void onResume() {
        super.onResume();
        Intent curIntent = getIntent();

        String action = curIntent.getAction();
        String type = curIntent.getType();

        if (Intent.ACTION_SEND.equals(action) && type != null && !curIntent.hasExtra("DONE")) {
            if ("text/plain".equals(type)) {
                handleShareURL(curIntent); // Handle text being sent
                curIntent.putExtra("DONE", true);
            }
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }


    void handleShareURL(Intent intent) {
        String sharedURL = intent.getStringExtra(Intent.EXTRA_TEXT);
        new MethodChannel(getFlutterView(), "app.channel.shared.data")
                .invokeMethod("getSharedURL", sharedURL);
    }
}
