import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:path/path.dart'; // Add this import for path.join
import 'package:mood_tracker/models/Pill_reminder/pill.dart';

//steps:
/*
1) first create all the Strings for column names and table name 
2) Create instance of DatabaseHelper only when it is null
3)getter for database
4)Initialise database
5)create table
6)accessing/ selecting data using list of mapped data
7)insert into table using db.insert and pill.toMap()
8)update 
9) delete
10)get count of all the entries in table 
11)// get map list from database
map list ko length jati hunu paryo count
 map list liera teslai  pilllist ma convert garera liney ani tyo naya form list ma add garne  , till count 
*/
class DatabaseHelper_pill {
  static DatabaseHelper_pill? _databaseHelper;
  static Database? _database;
  String PillTable = 'Pill_table';
  String PillId = 'id';
  String PillName = 'Mname';
  String Dose = 'Dose';
  String type = 'Mtype';
  String colInterval = 'interval';
  String coltime = 'time';
  // Fixed column name
  DatabaseHelper_pill._createInstance(); // Named constructor to create instance

  factory DatabaseHelper_pill() {
    // Create instance of DatabaseHelper only when it is null
    _databaseHelper ??= DatabaseHelper_pill._createInstance();
    return _databaseHelper!;
  }

  // Getter for database to access the database
  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }


  Future<Database> initializeDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'pills2.db');


    // Opening Creating database at the given path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    try{
      if (kDebugMode) {
        print(path);
      }

    }
    catch(e){
      print("error$e");

    }
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $PillTable($PillId INTEGER PRIMARY KEY AUTOINCREMENT, $PillName TEXT, $Dose TEXT, $type ,$colInterval TEXT,$coltime TEXT)');
  }

  Future<List<Map<String, dynamic>>> getPillMapList() async {
    Database db = await database;
    var result = await db.rawQuery('Select * from $PillTable');
    return result;
  }

  Future<int?> insertpill(Pill pill) async {
    Database db = await database;
  int?id;
    try {
      id = await db.insert(PillTable, pill.toMap());
      print('Details : $PillTable');
      print('$PillTable contains $id');
    } catch (e) {
      print("Error$e");
    }
    return id;
  }

  Future<int> updatepill(Pill pill) async {
    Database db = await database;
    var result = db.update(
      PillTable,
      pill.toMap(),
      where: '$PillId = ?',
      whereArgs: [pill.id],
    );
    return result;
  }

  Future<int> deletepill(int? id) async {
    Database db = await database;
    return await db.delete(
      PillTable,
      where: '$PillId = ?',
      whereArgs: [id],
    );
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $PillTable');
    return Sqflite.firstIntValue(x) ?? 0;
  }

  Future<List<Pill>> getPillList() async {
    var PillMapList = await getPillMapList();
    // Debugging statement// get map list from database
    int count = PillMapList.length; // map list ko length jati hunu paryo count
    List<Pill> pilllist = [];
    for (int i = 0; i < count; i++) {
   pilllist.add(Pill.fromMapObject(PillMapList[i])); // map list liera teslai  pilllist ma convert garera liney ani tyo naya form list ma add garne
    }
    return pilllist;
  }
}
