import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first_demo/map_view/address_select_in_map.dart';
import 'package:flutter_first_demo/model/poi_model.dart';
import '../constants.dart';

class MapSelectPage extends StatefulWidget {
  MapSelectPage({Key key}) : super(key: key);

  @override
  _MapSelectPageState createState() => _MapSelectPageState();
}

class _MapSelectPageState extends State<MapSelectPage> {
  var channel = MethodChannel(MapSelectPageMethodChannelName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('地图功能')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: Text('跳转导航'),
                onPressed: () async {
                  var start = PoiModel(
                      name: "北京首都国际机场",
                      coordinate: Coordinate(latitude: 39.918058, longitude: 116.397026),
                      poiid: "B000A28DAE");
                  var end = PoiModel(
                      name: "北京大学",
                      coordinate: Coordinate(latitude: 39.941823, longitude: 116.426319),
                      poiid: "B000A816R6");
                  try {
                    await channel.invokeMethod(MapSelectPageMethodChannelInvokeName,
                        [json.encode(start), json.encode(end)]);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              ElevatedButton(
                child: Text('地图选点'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressSelectInMapPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
