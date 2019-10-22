package com.paraxod.drillz;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "drillz.com/rate";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    final String method = call.method;
                    if (method.equals("launchStore")) {
                        goToPlayStore(call.argument("appId") == null ? getApplicationContext().getPackageName() : call.argument("appId").toString());
                        result.success(true);
                        return;
                    }

                    result.notImplemented();
                });
    }

    /**
     * Launches a Play Store instance.
     *
     * @param applicationId The application ID.
     */
    private void goToPlayStore(final String applicationId) {
        try {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + applicationId)));
        } catch (android.content.ActivityNotFoundException ex) {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + applicationId)));
        }
    }

}
