import 'package:flutter/material.dart';
import 'package:zoomqtt/settings/zoomQtt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZoomQtt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ZoomQtt(title: 'ZoomQtt'),
    );
  }
}
