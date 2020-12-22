import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class AddressSelectInMapPage extends StatefulWidget {
  AddressSelectInMapPage({Key key}) : super(key: key);

  @override
  _AddressSelectInMapPageState createState() => _AddressSelectInMapPageState();
}

class _AddressSelectInMapPageState extends State<AddressSelectInMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('appbarTitle'),
      ),
      body: AndroidView(
        viewType: "id",
        creationParams: {
          "url": selectAddressUrl,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          print('id: $id');
        },
      ),
    );
  }
}
