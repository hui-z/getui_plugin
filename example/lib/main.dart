import 'package:flutter/material.dart';
import 'package:getui/getui.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Getui.register(appID: '', appKey: '', appSecret: '');
    Getui.singleton().receivedClientID.listen((clientID) {
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('ClientID:' + (Getui.clientID() ?? '')),
        ),
      ),
    );
  }
}
