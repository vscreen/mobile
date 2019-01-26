package com.example.mobile;

import android.content.Intent;
import android.os.Bundle;
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

    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if (Intent.ACTION_VIEW.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        handleShareURL(intent); // Handle text being sent
      }
    }
  }

  void handleShareURL(Intent intent) {
    String sharedURL = intent.getStringExtra(Intent.EXTRA_TEXT);
    new MethodChannel(getFlutterView(), "app.channel.shared.data")
            .invokeMethod("getSharedURL", sharedURL);
  }
}
