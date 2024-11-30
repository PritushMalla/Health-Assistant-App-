import 'dart:io';
import 'package:mood_tracker/models/mood_tracker/mooddata.dart';
import 'package:mood_tracker/utils/mood_tracking_database/database_helper_sec.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHelper_Mood {
  static DatabaseHelper_Mood? _databaseHelper;
  static Database? _database;
  String moodTable = 'mood_table';
  String colId = 'id';
  String colDescription = 'description';
  String colDate = 'date';
  String colmoodtitle = 'moodtitle';
  DatabaseHelper_Mood._createInstance();

  factory DatabaseHelper_Mood() {
    // Create instance of DatabaseHelper only when it is null
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper_Mood._createInstance();
    return _databaseHelper!;
  }
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'moodnote2.db');
    print(path);
    // Opening/Creating database at the given path
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $moodTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colmoodtitle Text, $colDescription TEXT, $colDate TEXT)');
  }

  void _alterTable(Database db) async {
    await db.execute('ALTER TABLE $moodTable ADD COLUMN newColumnName Mtype');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database!;
  }

  Future<List<Map<String, dynamic>>> getMoodMapList() async {
    Database db = await database;
    var result = await db.rawQuery('Select * from $moodTable');

    return result;
  }

  Future<List<Map<String, dynamic>>> getMoodtitleMapList() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT * FROM $moodTable ORDER BY date DESC LIMIT 5');

    // Debugging output to see the retrieved data
    for (var moodData in result) {
      print("Retrieved Mood ID: ${moodData[colId]}, Mood: ${moodData[colmoodtitle]}, Date: ${moodData[colDate]}, Description: ${moodData[colDescription]}");
    }

    return result;
  }
  

  Future<List<MoodData>> getmoodtitleList() async {
    var moodtitleMapList = await getMoodtitleMapList();

    print(" the moodtitle map list print is $moodtitleMapList");
   // get map list from database
    DateTime today = DateTime.now();

    int count = moodtitleMapList.length;
    print("count is $count"); // map list ko length jati hunu paryo count
    List<MoodData> moodtitlelist = [];
    print("print moodtitlelist is $moodtitlelist");

    for (int i = 0; i < count; i++) {
      print(" count is $count");
      print(i);
      print(moodtitleMapList[i]);
      moodtitlelist.add(MoodData.fromtitleMapObject(moodtitleMapList[i]));
      print("moodtitle list is$moodtitlelist");

      // map list liera teslai  note list ma convert garera liney ani tyo naya form list ma add garne
    }

    return moodtitlelist;
  }

  Future<int> insertMood(MoodData moodata) async {
    Database db = await database;
    int id = 0;
    try {
      id = await db.insert(moodTable, moodata.toMap());
    } catch (e) {
      print("Error$e");
    }
    return id;
  }

  Future<int> updateMood(MoodData moodData) async {
    Database db = await database;
    var result = db.update(
      moodTable,
      moodData.toMap(),
      where: '$colId = ?',
      whereArgs: [moodData.id],
    );
    return result;
  }

  Future<int> deleteMood(int? id) async {
    Database db = await database;
    return await db.delete(
      moodTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<List<MoodData>> getmoodList() async {
    var moodMapList = await getMoodMapList(); // get map list from database
    int count = moodMapList.length; // map list ko length jati hunu paryo count
    List<MoodData> formlist = [];
    for (int i = 0; i < count; i++) {
      formlist.add(MoodData.fromMapObject(moodMapList[
          i])); // map list liera teslai  note list ma convert garera liney ani tyo naya form list ma add garne
    }
    return formlist;
  }

  Future<void> printSchema() async {
    Database db = await database;
    List<Map> result = await db.rawQuery('PRAGMA table_info(mood_table)');
    print(' \n$result');
  }
}
