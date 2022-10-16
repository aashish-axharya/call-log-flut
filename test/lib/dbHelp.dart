import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test/model.dart';

class DBHelper {
  static Future<Database> initdb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'callLog.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  static void onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE callLog (
        id INTEGER PRIMARY KEY,
        called_from TEXT,
        call_site TEXT,
        called_to TEXT,
        call_type TEXT,
        call_date TEXT,
        call_duration TEXT,
        call_remarks TEXT
      )
    ''');
  }

  static Future<int> createLogs(
      Database db, int oldVersion, int newVersion) async {
    Database db = await DBHelper.initdb();
    return await db.insert('callLog', CallModel().toJson());
  }

  static Future<List<CallModel>> readLogs() async {
    Database db = await DBHelper.initdb();
    List<Map<String, dynamic>> maps = await db.query('callLog');
    return List.generate(maps.length, (i) {
      return CallModel(
        id: maps[i]['id'],
        called_from: maps[i]['called_from'],
        call_site: maps[i]['call_site'],
        called_to: maps[i]['called_to'],
        call_type: maps[i]['call_type'],
        call_date: maps[i]['call_date'],
        call_duration: maps[i]['call_duration'],
        call_remarks: maps[i]['call_remarks'],
      );
    });
  }
}
