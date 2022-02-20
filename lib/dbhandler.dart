import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'objects.dart';

class DB_Handler {

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'catalog_mobile2.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE clase(id INTEGER PRIMARY KEY AUTOINCREMENT, an INTEGER NOT NULL, profil TEXT NOT NULL)");
        await database.execute("CREATE TABLE elevi(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, clasa TEXT NOT NULL)");
        await database.execute("CREATE TABLE absente(id INTEGER PRIMARY KEY AUTOINCREMENT, elev INTEGER NOT NULL, data TEXT NOT NULL)");
        await database.execute("CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT, elev INTEGER NOT NULL, nota INTEGER NOT NULL, data TEXT NOT NULL)");
      },
      version: 1
    );
  }

  Future<int> insertClasa(int an, String profil) async {
    int result = 0;
    final Database db = await initializeDatabase();
    result = await db.insert('clase', {"an": an, "profil": profil});
    return result;
  }

 Future<int> insertElev(String nume, String clasa) async {
   int result = 0;
   final Database db = await initializeDatabase();
   result = await db.insert('elevi', {"name": nume, "clasa": clasa});
   return result;
 }

 Future<int> insertAbsenta(int index, String date) async {
    int result = 0;
    final Database db = await initializeDatabase();
    result = await db.insert('absente', {"elev": index, "data": date});
    return result;
 }

  Future<int> insertNota(int index, int nota, String date) async {
    int result = 0;
    final Database db = await initializeDatabase();
    result = await db.insert('note', {"elev": index, "data": date, "nota": nota});
    return result;
  }

  Future<List<Elev>> getElevi(String clasa) async {
    final Database db = await initializeDatabase();
    final List<Map<String, Object?>> queryResult = await db.query('elevi', where: 'clasa = ?', whereArgs: [clasa], orderBy: 'name');
    List<Elev> elevi = [];
    for (Map<String, Object?> m in queryResult) {
      elevi.add(Elev.fromMap(m));
    }
    return elevi;
  }

  Future<List<String>> getClase() async {
      final Database db = await initializeDatabase();
      final List<Map<String, Object?>> queryResult = await db.query('clase', orderBy: 'an, profil',);
      List<String> clase = [];
      for (Map<String, dynamic> m in queryResult) {
        clase.add(m["an"].toString() + " " + m["profil"]);
      }
      return clase;
  }

  Future<List<String>> getAbsente(int index) async {
    final Database db = await initializeDatabase();
    final List<Map<String, Object?>> queryResult = await db.query('absente', where: 'elev = ?', whereArgs: [index], orderBy: 'data');
    List<String> absente = [];
    for (Map<String, dynamic> m in queryResult) {
      absente.add(m["data"]);
    }
    return absente;
  }

  Future<List<Map<String, dynamic>>> getNote(int index) async{
    final Database db = await initializeDatabase();
    final List<Map<String, Object?>> queryResult = await db.query('note', where: 'elev = ?', whereArgs: [index], orderBy: 'data');
    List<Map<String, dynamic>> note = [];
    for (Map<String, dynamic> m in queryResult) {
      note.add({"nota": m["nota"], "data": m["data"]});
    }
    return note;
  }

  Future<void> deleteElev(int id) async {
    final db = await initializeDatabase();
    await db.delete(
      'elevi',
      where: "id = ?",
      whereArgs: [id],
    );
    await db.delete(
      'absente',
      where: 'elev = ?',
      whereArgs: [id],
    );
    await db.delete(
      'note',
      where: 'elev = ?',
      whereArgs: [id],
    );
  }

}
