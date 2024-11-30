import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mood_tracker/models/professional/profs.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:path/path.dart';

class Databasehelper_prof {
  static Databasehelper_prof? _databasedatabasehelper;
  static Database? _database;
  String ProTable = 'Pro_Table';
  String docId = 'id';
  String pic = 'pic';
  String docname = 'name';
  String docspec = 'specialisation';
  String docContact = 'contact_info';
  String docAvailable = 'availability';

  Databasehelper_prof._createInstance(); // Named constructor to create instance

  factory Databasehelper_prof() {
    // Create instance of Databasedatabasehelper  only when it is null
    if (_databasedatabasehelper == null)
      _databasedatabasehelper = Databasehelper_prof._createInstance();
    return _databasedatabasehelper!;
  }

  // Getter for database to access the database
  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'Professional3.db');
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
        'CREATE TABLE $ProTable($docId INTEGER PRIMARY KEY AUTOINCREMENT, $docname TEXT, $docspec TEXT, $docAvailable TEXT,$docContact,$pic TEXT)');
  }

  Future<List<Map<String, dynamic>>> getProMapList() async {
    Database db = await database;
    var result = await db.rawQuery('Select * from $ProTable');
    return result;
  }

  Future<int> insertProf(Prof prof) async {
    Database db = await database;
    int id = 0;
    try {
      id = await db.insert(ProTable, prof.toMap());
      print('Details : $ProTable');
      print('$ProTable contains $id');
    } catch (e) {
      print("Error$e");
    }
    return id;
  }

  Future<void> insertDoctorPic(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert(
      'doctors',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePro(Prof prof) async {
    Database db = await database;
    var result = db.update(
      ProTable,
      prof.toMap(),
      where: '$docId = ?',
      whereArgs: [prof.id],
    );
    return result;
  }

  Future<int> deleteProf(int? id) async {
    Database db = await database;
    return await db.delete(
      ProTable,
      where: '$docId = ?',
      whereArgs: [id],
    );
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $ProTable');
    return Sqflite.firstIntValue(x) ?? 0;
  }

  Future<List<Prof>> getProList() async {
    var ProMapList = await getProMapList(); // get map list from database
    int count = ProMapList.length; // map list ko length jati hunu paryo count
    List<Prof> Prolist = [];
    for (int i = 0; i < count; i++) {
      Prolist.add(Prof.fromMapObject(ProMapList[
          i])); // map list liera teslai  proflist ma convert garera liney ani tyo naya Pro list ma add garne
    }
    return Prolist;
  }
}
