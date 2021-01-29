import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomqtt/settings/mqttService.dart';
import 'dart:async';
import 'package:zoomqtt/settings/notifyClass.dart';

class ZoomQtt extends StatefulWidget {
  ZoomQtt({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ZoomQttState createState() => _ZoomQttState();
}

class _ZoomQttState extends State<ZoomQtt> {
  var brokerAddressController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var topicController = TextEditingController();

  var enteredBrokerAddress;
  var enteredUsername;
  var enteredPassword;
  var enteredTopic;

  //vars for Mqtt
  MqttService mqttClient = MqttService();
  var streamController = StreamController();

  Future<Null> getSharedPrefs() async {
    print('Loading data to the form........');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      brokerAddressController =
          new TextEditingController(text: prefs.getString("prefBrokerAddress"));
      usernameController =
          new TextEditingController(text: prefs.getString("prefUsername"));
      passwordController =
          new TextEditingController(text: prefs.getString("prefPassword"));
      topicController =
          new TextEditingController(text: prefs.getString("prefTopic"));
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Widget build(BuildContext context) {
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
              SizedBox(height: 40),
              Text("logo here"),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 20),
                  Text('Address:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      controller: brokerAddressController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(4),
                          filled: true,
                          fillColor: Colors.white,
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
                  SizedBox(width: 30),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 50),
                  Text('Username:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      controller: usernameController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(4),
                          filled: true,
                          fillColor: Colors.white,
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
                  SizedBox(width: 50),
                  Text('Password:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      controller: passwordController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(4),
                          filled: true,
                          fillColor: Colors.white,
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
                  SizedBox(width: 70),
                  Text('   Topic:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      controller: topicController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(4),
                          filled: true,
                          fillColor: Colors.white,
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
                  SizedBox(width: 60),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 100),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Clear form",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    onPressed: () {
                      saveDataToPrefs();
                      if ((brokerAddressController.value.text != "") &&
                          (usernameController.value.text != "") &&
                          (passwordController.value.text != "") &&
                          (topicController.value.text != "")) {
                        mqttClient.connect(
                            usernameController.value.text,
                            passwordController.value.text,
                            brokerAddressController.value.text,
                            'testDevice',
                            topicController.value.text);
                      } else {
                        print('didnt try to connect');
                      }
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(width: 40),
                ],
              ),
              SizedBox(height: 40),
              Text("Footer + link here"),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  saveDataToPrefs() async {
    print('Saving data to form before Acting.......');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('prefBrokerAddress', enteredBrokerAddress);
    prefs.setString('prefUsername', enteredUsername);
    prefs.setString('prefPassword', enteredPassword);
    prefs.setString('prefTopic', enteredTopic);
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
