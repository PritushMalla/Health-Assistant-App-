import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:path/path.dart'; // Add this import for path.join
import 'package:mood_tracker/models/note/note.dart';

//steps:
/*
1) first create all the Strings for column names and table name 
2) Create instance of DatabaseHelper only when it is null
3)getter for database
4)Initialise database
5)create table
6)accessing/ selecting data using list of mapped data
7)insert into table using db.insert and note.toMap()
8)update 
9) delete
10)get count of all the entries in table 
11)// get map list from database
map list ko length jati hunu paryo count
 map list liera teslai  note list ma convert garera liney ani tyo naya form list ma add garne  , till count 
*/
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  String formTable = 'form_table';
  String formId = 'id';
  String formtitle = 'title';
  String formDescription = 'description';
  String formDate = 'date';
  String Emotion = 'emotion';
  String Scale = 'scale';

  // Fixed column name
  DatabaseHelper._createInstance(); // Named constructor to create instance

  factory DatabaseHelper() {
    // Create instance of DatabaseHelper only when it is null
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  // Getter for database to access the database
  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cbt3.db');
    print(path);
    // Opening Creating database at the given path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $formTable($formId INTEGER PRIMARY KEY AUTOINCREMENT, $formtitle TEXT, $formDescription TEXT,$Emotion TEXT, $Scale TEXT ,$formDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getFormMapList() async {
    Database db = await database;
    var result = await db.rawQuery('Select * from $formTable');
    return result;
  }

  Future<int> insertForm(Note note) async {
    Database db = await database;
    int id = 0;
    try {
      id = await db.insert(formTable, note.toMap());
      print('Details : $formTable');
      print('$formTable contains $id');
    } catch (e) {
      print("Error$e");
    }
    return id;
  }

  Future<int> updateForm(Note note) async {
    Database db = await database;
    var result = db.update(
      formTable,
      note.toMap(),
      where: '$formId =?',
      whereArgs: [note.id],
    );
    return result;
  }

  Future<int> deleteForm(int? id) async {
    Database db = await database;
    return await db.delete(
      formTable,
      where: '$formId = ?',
      whereArgs: [id],
    );
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $formTable');
    return Sqflite.firstIntValue(x) ?? 0;
  }

  Future<List<Note>> getFormList() async {
    var formMapList = await getFormMapList(); // get map list from database
    int count = formMapList.length; // map list ko length jati hunu paryo count
    List<Note> formlist = [];
    for (int i = 0; i < count; i++) {
      formlist.add(Note.fromMapObject(formMapList[
          i])); // map list liera teslai  note list ma convert garera liney ani tyo naya form list ma add garne
    }
    return formlist;
  }
}
