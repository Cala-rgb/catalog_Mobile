import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'objects.dart';

class DB_Handler {
  
  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    print(path);
    return openDatabase(
      join(path, 'catalog.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE elevi(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, clasa TEXT NOT NULL)",
        );
      },
      version: 1
    );
  }

 Future<int> insertElev(List<Elev> elevi) async {
    int result = 0;
    final Database db = await initializeDatabase();
    for (var elev in elevi) {
      result = await db.insert('elevi', elev.toMap());
    }
    return result;
 }

  Future<List<Elev>> retrieveUsers() async {
    final Database db = await initializeDatabase();
    final List<Map<String, Object?>> queryResult = await db.query('elevi');
    return queryResult.map((e) => Elev.fromMap(e)).toList();
  }

  Future<void> deleteElev(int id) async {
    final db = await initializeDatabase();
    await db.delete(
      'elevi',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}
