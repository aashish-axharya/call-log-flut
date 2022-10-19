import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveData extends StatefulWidget {
  const SaveData({Key? key}) : super(key: key);
  @override
  SaveDataState createState() => SaveDataState();
}

class SaveDataState extends State<SaveData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Save Data'),
          ],
        ),
      ),
    );
  }
}
