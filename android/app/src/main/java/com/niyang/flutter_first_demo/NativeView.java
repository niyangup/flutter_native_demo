package com.niyang.flutter_first_demo;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

class NativeView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String TAG = "NativeView";
    private static final String METHOD_CHANNEL_NAME = "name";
    @NonNull
    private final TextView textView;

    NativeView(@NonNull Context context, BinaryMessenger messenger, int id, @Nullable Map<String, Object> creationParams) {
        textView = new TextView(context);
        textView.setTextSize(72);
        textView.setBackgroundColor(Color.rgb(255, 255, 255));
        textView.setText("Rendered on a native Android view (id: " + id + ")");
        if (creationParams != null) {
            textView.setText(creationParams.get("myContent").toString());
        }
        //注册methodChannel
        new MethodChannel(messenger, METHOD_CHANNEL_NAME).setMethodCallHandler(this);
    }

    @NonNull
    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("eat")) {
            Log.d(TAG, "onMethodCall: eat");
            List<String> data = (List<String>) call.arguments;
            textView.setText(data.get(1));
            result.success("eat");
        } else {
            result.notImplemented();
        }
    }
}
