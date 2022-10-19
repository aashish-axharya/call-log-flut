import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test/saveData.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<void> _logOut() async {
  final SharedPreferences prefs = await _prefs;
  prefs.setBool('isLoggedIn', false);
  prefs.setString('username', '');
  prefs.setString('password', '');
}

class ApiTest extends StatefulWidget {
  @override
  ApiTestState createState() => ApiTestState();
}

class ApiTestState extends State<ApiTest> {
  getData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var username = prefs.getString('username');
    var password = prefs.getString('password');

    List<dynamic> called_from = [];
    List<dynamic> called_to = [];
    List<dynamic> call_site = [];
    List<dynamic> call_type = [];
    List<dynamic> call_date = [];
    List<dynamic> call_duration = [];
    List<dynamic> call_remarks = [];

    var auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await http.get(
        Uri.parse(
            'http://192.168.2.74:5000/search/called_from,Aashish Acharya'),
        headers: <String, String>{
          'authorization': auth,
          'connection': 'keep-alive',
        });
    var jsonData = json.decode(response.body);
    try {
      for (var i = 0; i < jsonData.length; i++) {
        called_from.add(jsonData[i]['called_from'][1]);
        called_to.add(jsonData[i]['called_to']);
        call_site.add(jsonData[i]['call_site'][1]);
        call_type.add(jsonData[i]['call_type']);
        call_date.add(jsonData[i]['call_date']);
        call_duration.add(jsonData[i]['call_duration']);
        call_remarks.add(jsonData[i]['call_remarks']);
      }
    } catch (e) {
      print(e);
    }

    var dataList = [
      for (var i = 0; i < jsonData.length; i++)
        {
          'called_from': called_from[i],
          'called_to': called_to[i],
          'call_site': call_site[i],
          'call_type': call_type[i],
          'call_date': call_date[i],
          'call_duration': call_duration[i],
          'call_remarks': call_remarks[i]
        }
    ];
    return (dataList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Test"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SaveData()));
              },
              icon: const Icon(Icons.save)),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                passwordController.clear();
                _logOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Container(
          child: Card(
              child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var row1 = snapshot.data[index]['call_site'] +
                      " - " +
                      snapshot.data[index]['called_to'];
                  var row2 = snapshot.data[index]['call_date'] +
                      " Duration = " +
                      snapshot.data[index]['call_duration'].toString() +
                      " sec" +
                      "\nDescription = " +
                      snapshot.data[index]['call_remarks'];

                  // Icons according to call type
                  dynamic callIcon;
                  if (snapshot.data[index]['call_type'] == 'outgoing') {
                    callIcon = Icons.call_made;
                  } else if (snapshot.data[index]['call_type'] == 'incoming') {
                    callIcon = Icons.call_received;
                  } else {
                    callIcon = Icons.call_missed;
                  }

                  return ListTile(
                    leading: Icon(callIcon),
                    title: Text(row1),
                    subtitle: Text(row2),
                  );
                });
          }
        },
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // CallLogData().createTable();
          print('here');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
