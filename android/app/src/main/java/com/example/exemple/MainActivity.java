package com.example.exemple;
import com.orange.webcom.sdk.*;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.util.Log;
import java.util.ArrayList;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "plugin.plb.io/authWebcom";

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                  @Override
                  public void onMethodCall(MethodCall call, final Result result) {
                      if (call.method.equals("authWebcom")) {

                        final String TAG = "WebcomTAG";
                        try{
                          // Create a connection to the back-end
                          Webcom ref = new Webcom("https://io.datasync.orange.com/base/coding-room-events");
                          // OAuth listener definition
                          final OnAuthWithOAuth listener = new OnAuthWithOAuth() {
                              @Override
                              public void onCancel( WebcomError error) {
                                  Log.d(TAG, "User cancels authentication");
                              }
                              @Override
                              public void onComplete(AuthResponse response) {
                                  if (response == null) Log.d(TAG, "Logged out!");
                                  else {
                                    ArrayList listA = new ArrayList( );

                                    listA.add(response.getIdentity().getProviderProfile());
                                    listA.add(response.getIdentity().getWebcomAuthToken());
                                    listA.add(response.getIdentity().getUid());
                                      Log.d(TAG, "Logged in: " + response.getIdentity().getDisplayName());
                                      result.success(listA);
                                  }
                              }
                              @Override
                              public void onError(WebcomError error) {
                                  Log.e(TAG, "Authentication error: " + error.getMessage());
                              }
                          };
                          ref.authWithOAuth(MainActivity.this, "google", listener);
                      } catch (Exception e) {
                          Log.e(TAG, e.getMessage(), e);
                      }
                       
                      } else {
                          result.notImplemented();
                      }
                  }
                });
    }
}
