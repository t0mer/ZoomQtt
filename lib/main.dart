import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ZoomQtt extends StatefulWidget {
  ZoomQtt({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ZoomQttState createState() => _ZoomQttState();
}

class _ZoomQttState extends State<ZoomQtt> {
  var _brokerAddressController = TextEditingController();
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _topicController = TextEditingController();

  var enteredBrokerAddress;
  var enteredUsername;
  var enteredPassword;
  var enteredTopic;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _brokerAddressController =
          new TextEditingController(text: prefs.getString("prefBrokerAddress"));
      _usernameController =
          new TextEditingController(text: prefs.getString("prefUsername"));
      _passwordController =
          new TextEditingController(text: prefs.getString("prefPassword"));
      _topicController =
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
                      controller: _brokerAddressController,
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
                      controller: _usernameController,
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
                      controller: _passwordController,
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
                      controller: _topicController,
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
                      goOpenZoom();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('prefBrokerAddress', enteredBrokerAddress);
    prefs.setString('prefUsername', enteredUsername);
    prefs.setString('prefPassword', enteredPassword);
    prefs.setString('topic', enteredTopic);
  }

  goOpenZoom() {
    //TODO: Adam , Do it here !
  }
}
