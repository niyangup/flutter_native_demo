import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:flutter/foundation.dart';

class PushPage extends StatefulWidget {
  PushPage({Key key}) : super(key: key);

  @override
  _PushPageState createState() => _PushPageState();
}

class _PushPageState extends State<PushPage> {
  @override
  void initState() {
    super.initState();
    MobpushPlugin.updatePrivacyPermissionStatus(true);
    if (Platform.isIOS) {
      MobpushPlugin.setCustomNotification();
      MobpushPlugin.setAPNsForProduction(kReleaseMode);
    }
    MobpushPlugin.addPushReceiver(_onEvent, _onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('appbarTitle'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: Text('停止/恢复推送'),
                onPressed: () async {
                  if (await MobpushPlugin.isPushStopped()) {
                    await MobpushPlugin.restartPush();
                    print('已恢复');
                  } else {
                    await MobpushPlugin.stopPush();
                    print('已停止');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onEvent(Object event) {
    print('接收到event $event');
  }

  _onError(Object event) {
    print('接收到error $event');
  }
}
