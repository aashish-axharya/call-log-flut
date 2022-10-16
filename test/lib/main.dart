import 'package:flutter/material.dart';
import 'package:test/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: getHome());
  }
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<void> _setLoggedIn() async {
  final SharedPreferences prefs = await _prefs;
  prefs.setBool('isLoggedIn', true);
  prefs.setString('username', usernameController.text);
  prefs.setString('password', passwordController.text);
}

Future<bool> _getLoggedIn() async {
  final SharedPreferences prefs = await _prefs;
  return Future.value(prefs.getBool('isLoggedIn'));
}

getHome() {
  return FutureBuilder(
      future: _getLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return ApiTest();
        } else {
          return Login();
        }
      });
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  isLoggedin() async {
    var username = usernameController.text;
    var password = passwordController.text;
    var auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await http.get(
        Uri.parse('http://192.168.2.74:5000/authorize/$username,$password'),
        headers: <String, String>{
          'authorization': auth,
          'connection': 'keep-alive',
        });
    var jsonData = json.decode(response.body);
    if (jsonData['status'] == 'success') {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                ),
              )),
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 10),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              onPressed: () {
                var status;
                isLoggedin().then((value) {
                  status = value;
                  if (status == true) {
                    _setLoggedIn();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ApiTest()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Authentication Error"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                });
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
