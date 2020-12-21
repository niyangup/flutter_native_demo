import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class NativeViewPage extends StatefulWidget {
  NativeViewPage({Key key}) : super(key: key);

  @override
  _NativeViewPageState createState() => _NativeViewPageState();
}

class _NativeViewPageState extends State<NativeViewPage> {
  MethodChannel _channel = MethodChannel(NativeViewPageMethodChannelName);

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
            child: Text('用MethodChannel切换内容'),
            onPressed: () async {
              String msg = await _channel.invokeMethod<String>(
                  NativeViewPageMethodChannelInvokeName, ["this is text", "this is haha"]);
              print(msg);
            },
          )
        ],
      ),
    );
  }
}
