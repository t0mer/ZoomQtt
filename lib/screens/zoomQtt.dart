import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomqtt/settings/mqttService.dart';

class ZoomQtt extends StatefulWidget {
  static const String id = 'zoomQtt';
  ZoomQtt({this.title});
  final String title;
  @override
  _ZoomQttState createState() => _ZoomQttState();
}

class _ZoomQttState extends State<ZoomQtt> {
  bool settingLock = true;
  String url = "https://www.google.com";
  var brokerAddressController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var topicController = TextEditingController();

  var enteredBrokerAddress;
  var enteredUsername;
  var enteredPassword;
  var enteredTopic;

  //vars for Mqtt
  // MqttService mqttClient = MqttService();

  Future<Null> getSharedPrefs() async {
    print('Loading data to the form........');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      brokerAddressController =
          TextEditingController(text: prefs.getString("prefBrokerAddress"));
      usernameController =
          TextEditingController(text: prefs.getString("prefUsername"));
      passwordController =
          TextEditingController(text: prefs.getString("prefPassword"));
      topicController =
          TextEditingController(text: prefs.getString("prefTopic"));
    });
  }

  void loginToMqtt() {
    if ((brokerAddressController.value.text != "") &&
        (usernameController.value.text != "") &&
        (passwordController.value.text != "") &&
        (topicController.value.text != "")) {
      Provider.of<MqttService>(context, listen: false).connect(
          usernameController.value.text,
          passwordController.value.text,
          brokerAddressController.value.text,
          topicController.value.text,
          "${topicController.value.text}/zoomqtt");
    } else {
      print('didnt try to connect');
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs().then((value) {
      loginToMqtt();
    });
  }

  Widget build(BuildContext context) {
    return Consumer<MqttService>(
      builder: (context, mqttData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/orengLogo.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  OutlineButton(
                      textColor: Colors.orange[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        launch(url, forceSafariVC: false);
                      },
                      child: Text('Go to the Guide')),
                  SizedBox(height: 20),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(
                          20.0), //I used some padding without fixed width and height
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: mqttData.isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        !settingLock ? "Settings Unlocked" : "Settings Locked",
                        style: TextStyle(
                            color: settingLock
                                ? Colors.red[300]
                                : Colors.green[900]),
                      ),
                      Switch(
                        value: settingLock,
                        onChanged: (value) {
                          setState(() {
                            settingLock = !settingLock;
                          });
                        },
                        activeTrackColor: Colors.redAccent[100],
                        activeColor: Colors.redAccent[100],
                        inactiveTrackColor: Colors.green[900],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 20),
                      Text('Address:'),
                      SizedBox(width: 40),
                      Expanded(
                        child: TextField(
                          readOnly: settingLock,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: brokerAddressController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(4),
                              filled: true,
                              fillColor: settingLock
                                  ? Colors.blueGrey[100]
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              )),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          onChanged: (newText) {
                            enteredBrokerAddress = newText.trim();
                          },
                        ),
                      ),
                      SizedBox(width: 60),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 20),
                      Text('Username:'),
                      SizedBox(width: 30),
                      Expanded(
                        child: TextField(
                          readOnly: settingLock,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: usernameController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(4),
                              filled: true,
                              fillColor: settingLock
                                  ? Colors.blueGrey[100]
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              )),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          onChanged: (newText) {
                            enteredUsername = newText.trim();
                          },
                        ),
                      ),
                      SizedBox(width: 60),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 20),
                      Text('Password:'),
                      SizedBox(width: 30),
                      Expanded(
                        child: TextField(
                          readOnly: settingLock,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: passwordController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(4),
                              filled: true,
                              fillColor: settingLock
                                  ? Colors.blueGrey[100]
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              )),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          textAlign: TextAlign.left,
                          onChanged: (newText) {
                            enteredPassword = newText.trim();
                          },
                        ),
                      ),
                      SizedBox(width: 60),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 20),
                      Text('Topic:'),
                      SizedBox(width: 60),
                      Expanded(
                        child: TextField(
                          readOnly: settingLock,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: topicController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(4),
                              filled: true,
                              fillColor: settingLock
                                  ? Colors.blueGrey[100]
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              )),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          onChanged: (newText) {
                            enteredTopic = newText.trim();
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "/zoomqtt",
                        style: TextStyle(fontSize: 22.0),
                      ),
                      SizedBox(width: 100),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 40),
                      FlatButton(
                        onPressed: () {
                          clearDataPrefs();
                          getSharedPrefs();
                        },
                        child: Text(
                          "Clear form",
                          style: TextStyle(
                              color: settingLock ? Colors.red : Colors.white),
                        ),
                        color: settingLock ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(width: 10),
                      FlatButton(
                        onPressed: () {
                          if ((brokerAddressController.value.text != "") &&
                              (usernameController.value.text != "") &&
                              (passwordController.value.text != "") &&
                              (topicController.value.text != "")) {
                            saveDataToPrefs(
                                enteredBrokerAddress:
                                    brokerAddressController.value.text,
                                enteredPassword: passwordController.value.text,
                                enteredTopic: topicController.value.text,
                                enteredUsername: usernameController.value.text);
                          } else {
                            print('didnt try to connect');
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: settingLock ? Colors.red : Colors.white),
                        ),
                        color: settingLock ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(width: 10),
                      FlatButton(
                        onPressed: () {
                          if ((brokerAddressController.value.text != "") &&
                              (usernameController.value.text != "") &&
                              (passwordController.value.text != "") &&
                              (topicController.value.text != "")) {
                            mqttData.connect(
                                usernameController.value.text,
                                passwordController.value.text,
                                brokerAddressController.value.text,
                                topicController.value.text,
                                "${topicController.value.text}/zoomqtt");
                          } else {
                            print('didnt try to connect');
                          }
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: settingLock ? Colors.red : Colors.white),
                        ),
                        color: settingLock ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                  SizedBox(height: 40),

                  // SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  saveDataToPrefs(
      {String enteredBrokerAddress,
      String enteredUsername,
      String enteredPassword,
      String enteredTopic}) async {
    print('Saving data to form before Acting.......');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('prefBrokerAddress', enteredBrokerAddress);
    prefs.setString('prefUsername', enteredUsername);
    prefs.setString('prefPassword', enteredPassword);
    prefs.setString('prefTopic', enteredTopic);
  }

  clearDataPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('prefBrokerAddress');
    prefs.remove('prefUsername');
    prefs.remove('prefPassword');
    prefs.remove('prefTopic');
  }
}
