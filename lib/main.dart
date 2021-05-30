import 'package:flutter/material.dart';
import 'package:zoomqtt/settings/mqttService.dart';
import 'package:zoomqtt/screens/zoomQtt.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MqttService(),
      child: MaterialApp(
        title: 'ZoomQtt',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        routes: {
          ZoomQtt.id: (context) => ZoomQtt(title: 'ZoomQtt'),
        },
        initialRoute: ZoomQtt.id,
      ),
    );
  }
}
