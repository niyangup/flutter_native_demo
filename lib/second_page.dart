import 'dart:async';

import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final controller = StreamController<int>.broadcast();
  int total = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await Future.delayed(Duration(seconds: 2), () {
      controller.sink.addError(Exception("this is exception"));
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('appbarTitle')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.sink.add(total);
        },
      ),
      body: Center(
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 30, color: Colors.black),
          child: StreamBuilder(
            stream: controller.stream.distinct(),
            builder: (context, snapshot) {
              print('this is builder');
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('没有数据');
                  break;
                case ConnectionState.waiting:
                  return Text('等待中');
                  // return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return Text('错误 ${snapshot.error}');
                  } else {
                    return Text('正常 ${snapshot.data}');
                  }
                  break;
                case ConnectionState.done:
                  return Text('结束');
                  break;
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
