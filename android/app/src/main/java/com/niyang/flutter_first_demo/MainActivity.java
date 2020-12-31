package com.niyang.flutter_first_demo;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;

import com.amap.api.maps.model.Poi;
import com.amap.api.navi.AmapNaviPage;
import com.amap.api.navi.AmapNaviParams;
import com.amap.api.navi.AmapNaviType;
import com.amap.api.navi.AmapPageType;
import com.google.gson.Gson;

import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler, LifecycleObserver {

    private static final String TAG = "MainActivity";
    private static final String METHOD_CHANNEL_NAME = "map_method";
    private static final String METHOD_CHANNEL_NAME_Invoke = "goMap";


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "onCreate: ");
        getLifecycle().addObserver(this);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "onStart: ");
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d(TAG, "onResume: ");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.d(TAG, "onPause: ");
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "onStop: ");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy: ");
    }


    /**
     * 感知生命周期
     */
    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    private void logNow() {
        Log.d(TAG, "ON_RESUME: ");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "configureFlutterEngine: ");
        flutterEngine
                .getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("id", new NativeViewFactory(flutterEngine.getDartExecutor().getBinaryMessenger()));
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL_NAME).setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals(METHOD_CHANNEL_NAME_Invoke)) {
            Log.d(TAG, "onMethodCall: " + call.arguments);
            if (call.arguments != null) {
                handleToMapView(call.arguments);
                result.success(null);
            }
        } else {
            result.notImplemented();
        }
    }

    private void handleToMapView(Object arguments) {
        Log.d(TAG, "onMethodCall: METHOD_CHANNEL_NAME_Invoke");
//        AmapNaviParams params = new AmapNaviParams(null, null, null, AmapNaviType.DRIVER, AmapPageType.ROUTE);
//        AmapNaviPage.getInstance().showRouteActivity(getApplicationContext(), params, null);
//        Poi start = new Poi("北京首都机场", new LatLng(40.080525, 116.603039), "B000A28DAE");
//        Poi end = new Poi("北京大学", new LatLng(39.941823, 116.426319), "B000A816R6");
        List<String> list = (List<String>) arguments;
        Gson gson = new Gson();
        Poi start = gson.fromJson(list.get(0), Poi.class);
        Poi end = gson.fromJson(list.get(1), Poi.class);
        AmapNaviParams params = new AmapNaviParams(start, null, end, AmapNaviType.DRIVER, AmapPageType.ROUTE);
        AmapNaviPage.getInstance().showRouteActivity(getApplicationContext(), params, null);


    }
}
