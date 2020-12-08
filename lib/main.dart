import 'package:flutter/material.dart';
import 'package:flutter_first_demo/second_page.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int total = 10;
  ValueNotifier distance = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chevron_right),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels < 0) {
              return false;
            }
            distance.value = notification.metrics.pixels;
            print(distance.value / 300);
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 3));
            total += 10;
            setState(() {});
          },
          child: CustomScrollView(
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverAppBar(
                stretch: false,
                expandedHeight: 300,
                title: ValueListenableBuilder(
                  valueListenable: distance,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: (distance.value / 300) > 0
                          ? (distance.value / 300) > 1
                              ? 1
                              : distance.value / 300
                          : 0,
                      child: Text('text'),
                    );
                  },
                ),
                centerTitle: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                  background: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Image.network(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
