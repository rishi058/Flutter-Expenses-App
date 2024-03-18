import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        price REAL,
        raw_date TEXT,
        view_date TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
        'expenses1.db',
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        }
        );
  }


  // CREATE A NEW NOTE -->
  static Future<int> createItem(String TITLE, int PRICE, String raw_date, String view_date ) async{

    final db = await SQLHelper.db();

    final data = {'title' : TITLE, 'price': PRICE, 'raw_date': raw_date, 'view_date': view_date};

    final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;

  }

  //READ ALL NOTE -->
  static Future<List<Map<String, dynamic>>> getItems() async{
    final db = await SQLHelper.db();

    return db.query('items', orderBy: "id");
  }


  // Delete -->

  static Future<void> deleteItem(int id) async {

    final db = await SQLHelper.db();

    try { await db.delete("items", where: "id = ?", whereArgs: [id]);}
    catch (err) { debugPrint("Something went wrong when deleting an item: $err"); }
  }


}
