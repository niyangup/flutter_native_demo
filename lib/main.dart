import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first_demo/second_page.dart';

import 'map_view/map_select_page.dart';
import 'native_view/native_view_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int total = 12;
  ValueNotifier distance = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: _buildFloatingActionButton(context),
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleNotification,
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 3));
            total += 10;
            setState(() {});
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(),
              _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  bool _handleNotification(notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels < 0) {
        return false;
      }
      distance.value = notification.metrics.pixels;
      print(distance.value / 300);
    }
    return false;
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.chevron_right),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NativeViewPage()));
      },
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      stretch: false,
      expandedHeight: 300,
      title: ValueListenableBuilder(
        valueListenable: distance,
        builder: (context, value, child) {
          return Text(
            'text',
            style: TextStyle(
                color: Colors.white.withOpacity((distance.value / 300) > 0
                    ? (distance.value / 300) > 1
                        ? 1
                        : distance.value / 300
                    : 0)),
          );
        },
      ),
      centerTitle: true,
      pinned: true,
      flexibleSpace: _buildFlexibleSpaceBar(),
      actions: [
        PopupMenuButton<String>(
          onSelected: (String value) {
            var page;
            if (value == "Stream") {
              page = SecondPage();
            } else if (value == "AndroidView") {
              page = NativeViewPage();
            } else if (value == "Map") {
              page = MapSelectPage();
            } else if (value == "Push") {
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'Stream', child: Text('Stream')),
              PopupMenuItem<String>(value: 'AndroidView', child: Text('AndroidView')),
              PopupMenuItem<String>(value: 'Map', child: Text('Map')),
              // PopupMenuItem<String>(value: 'Push', child: Text('Push')),
            ];
          },
        )
      ],
    );
  }

  FlexibleSpaceBar _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      stretchModes: <StretchMode>[
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
        StretchMode.fadeTitle,
      ],
      centerTitle: true,
      background: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Image.asset(
          "assets/img/pic_head.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SliverToBoxAdapter(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: total,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text('Sunday'),
            subtitle: Text('sunny, h: 80, l: 65'),
          );
        },
      ),
    );
  }
}
