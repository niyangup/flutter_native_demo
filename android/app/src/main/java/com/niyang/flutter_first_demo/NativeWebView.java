package com.niyang.flutter_first_demo;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.webkit.ConsoleMessage;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class NativeWebView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String TAG = "NativeWebView";
    private static final String METHOD_CHANNEL_NAME = "webview_name";


    @NonNull
    private final WebView mWebView;

    private Context context;


    NativeWebView(@NonNull Context context, BinaryMessenger messenger, int id, @Nullable Map<String, Object> creationParams) {
        this.context = context;
        mWebView = new WebView(context);
        WebSettings settings = mWebView.getSettings();
        settings.setBuiltInZoomControls(true);// 滑动后显示缩放按钮(wap网页不支持)
        settings.setUseWideViewPort(true);// 支持双击缩放(wap网页不支持)

        settings.setJavaScriptEnabled(true);// 支持js功能

        mWebView.loadUrl(creationParams.get("url").toString());
//        mWebView.loadUrl("file:///android_asset/select_map.html");
        mWebView.setWebViewClient(new WebViewClient() {

            // 开始加载网页时调用
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
            }

            // 网页加载结束调用
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
            }

            // 所有连接跳转会走此方法
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

        });

        mWebView.setWebChromeClient(new WebChromeClient() {

            // 进度发生变化
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
                Log.v("tag", "进度:" + newProgress);
            }

            // 网页标题
            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                Log.v("tag", "网页标题:" + title);
            }

            @Override
            public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
                Log.d(TAG, "url: " + url);
                Log.d(TAG, "message: " + message);
                Log.d(TAG, "result: " + result);

                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.setTitle("来自网页的消息")
                        .setMessage(message)
                        .setPositiveButton("确定", (dialog, which) -> dialog.dismiss())
                        .create().show();
                return super.onJsAlert(view, url, message, result);
            }

            @Override
            public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
                Log.d(TAG, "onConsoleMessage: " + consoleMessage.message());
                return super.onConsoleMessage(consoleMessage);
            }
        });
        //注册methodChannel
        new MethodChannel(messenger, METHOD_CHANNEL_NAME).setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return mWebView;
    }

    @Override
    public void dispose() {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

    }

}
