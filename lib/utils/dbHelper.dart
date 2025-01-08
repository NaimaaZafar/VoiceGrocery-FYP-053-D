import 'package:sqflite/sqflite.dart';

Database? _database;

class dbHelper{
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Local.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {

  }
}