import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class MqttService extends ChangeNotifier {
  String messageReciver;
  bool isNew = false;
  bool isConnected = false;
  Future<MqttServerClient> connect(String username, String password,
      String brokerUrl, String clientID, String topic) async {
    MqttServerClient client =
        MqttServerClient.withPort(brokerUrl, clientID, 1883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs(username, password)
        .withClientIdentifier(clientID)
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect(username, password);
      subscribe(client, topic);
      client.connectionStatus;
      clientListe(client);
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    return client;
  }

// subscribe to topic
  void subscribe(MqttServerClient client, String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    onSubscribed(topic);
  }

  void clientListe(MqttServerClient client) {
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print('Received message:$payload from topic: ${c[0].topic}>');
      final body = json.decode(payload);
      print(body['msg']);
      messageReciver = body['msg'];
      isNew = true;
      openLink(messageReciver);
      notifyListeners();
    });
  }

  // Disconnect from Mqtt
  void disconnect(MqttServerClient client) {
    client.disconnect();
  }

  // connection succeeded
  void onConnected() {
    print('Connected');
    isConnected = true;
    notifyListeners();
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
    isConnected = false;
    notifyListeners();
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  void openLink(String url) {
    if (isNew) {
      launch(url, forceSafariVC: false);
      isNew = !isNew;
    }
  }
}
