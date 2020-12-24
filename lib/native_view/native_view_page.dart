import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class NativeViewPage extends StatefulWidget {
  NativeViewPage({Key key}) : super(key: key);

  @override
  _NativeViewPageState createState() => _NativeViewPageState();
}

class _NativeViewPageState extends State<NativeViewPage> {
  MethodChannel _channel;
  BasicMessageChannel _basicMessageChannel;
  EventChannel _eventChannel;

  ///原生使用MethodChannel发来的消息
  String nativeMethodChannelText = "暂无消息";

  ///原生使用basicMessageChannel发送的消息
  String basicMessageChannelText = "暂无消息";

  int count = 0;

  @override
  void initState() {
    super.initState();
    _basicMessageChannel =
        BasicMessageChannel(NativeViewPageBasicMessageChannelName, const StandardMessageCodec());
    _channel = MethodChannel(NativeViewPageMethodChannelName);
    _eventChannel = EventChannel(NativeViewPageEventChannelName);
    _channel.setMethodCallHandler((call) {
      print('call ${call.method}');
      print('call ${call.arguments}');
      nativeMethodChannelText = call?.arguments?.toString();
      if (mounted) setState(() {});
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('appbarTitle')),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Platform.isAndroid
                ? AndroidView(
                    viewType: "id",
                    creationParams: {
                      "myContent": "通过参数传入的文本内容,I am 原生view",
                    },
                    creationParamsCodec: const StandardMessageCodec(),
                    onPlatformViewCreated: (int id) {
                      print('id: $id');
                    },
                  )
                : Center(child: Text('暂不支持')),
          ),
          ElevatedButton(
            child: Text('用MethodChannel通知原生切换内容'),
            onPressed: () async {
              String msg = await _channel.invokeMethod<String>(
                  NativeViewPageMethodChannelInvokeName, ["this is text", "this is haha"]);
              print(msg);
            },
          ),
          ElevatedButton(
            child: Text('原生使用MethodChannel主动给flutter发消息'),
            onPressed: () async {
              await _channel.invokeMethod<String>("handleNativeToFlutter");
            },
          ),
          Center(
            child: Text(
              nativeMethodChannelText,
              style: TextStyle(fontSize: 40),
            ),
          ),
          ElevatedButton(
            child: Text('BasicMessageChannel发送消息'),
            onPressed: () async {
              var data = await _basicMessageChannel.send("flutter发出的消息");
              basicMessageChannelText = data;
              if (mounted) setState(() {});
            },
          ),
          Center(
            child: Text(
              basicMessageChannelText,
              style: TextStyle(fontSize: 40),
            ),
          ),
          ElevatedButton(
            child: Text('使用MethodChannel向Stream添加信息或错误'),
            onPressed: () async {
              _channel.invokeMethod("addMsg", ++count);
            },
          ),
          StreamBuilder(
              initialData: "暂无消息",
              stream: _eventChannel.receiveBroadcastStream(),
              builder: (context, snapshot) {
                return Center(
                  child: Text(
                    "eventChannel监听的数据:${snapshot.data.toString()}",
                    style: TextStyle(fontSize: 40),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
