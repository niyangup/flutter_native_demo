package com.niyang.flutter_first_demo;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;

class NativeView implements PlatformView, MethodChannel.MethodCallHandler, BasicMessageChannel.MessageHandler, EventChannel.StreamHandler {
    private static final String TAG = "NativeView";
    private static final String METHOD_CHANNEL_NAME = "name";
    private static final String BASIC_CHANNEL_NAME = "NativeViewPageBasicMessageChannelName";
    private static final String EVENT_CHANNEL_NAME = "NativeViewPageEventChannelName";
    @NonNull
    private final TextView textView;
    private Context context;
    private MethodChannel channel;
    private BasicMessageChannel basicMessageChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink events;

    NativeView(@NonNull Context context, BinaryMessenger messenger, int id, @Nullable Map<String, Object> creationParams) {
        this.context = context;
        textView = new TextView(context);
        textView.setTextSize(72);
        textView.setBackgroundColor(Color.rgb(255, 255, 255));
        textView.setText("Rendered on a native Android view (id: " + id + ")");
        if (creationParams != null) {
            textView.setText(creationParams.get("myContent").toString());
        }
        //注册methodChannel
        channel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        channel.setMethodCallHandler(this);

        basicMessageChannel = new BasicMessageChannel(messenger, BASIC_CHANNEL_NAME, new StandardMessageCodec());
        basicMessageChannel.setMessageHandler(this);

        eventChannel = new EventChannel(messenger, EVENT_CHANNEL_NAME);
        eventChannel.setStreamHandler(this);
    }

    /**
     * 原生主动向flutter发送消息[methodChannel]
     */
    private void handleNativeToFlutter() {
        new Handler().post(() -> {
            Log.d(TAG, "NativeView: 发送消息");
            channel.invokeMethod("flutter", "原生发来的消息");
        });
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
        } else if (call.method.equals("handleNativeToFlutter")) {
            handleNativeToFlutter();
        } else if (call.method.equals("addMsg")) {
            if (call.arguments != null) {
                Integer type = (Integer) call.arguments;
                events.success(type);
            }

        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onMessage(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
        if (message != null) {
            Log.d(TAG, "onMessage: 原生端收到消息" + message);
            reply.reply("来自Android中basicMessageChannel的回复");
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
        this.events = null;
    }
}
