import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

late String category;

class DatabaseHelper {
  //Creates a table

  static void setCategory(String input) {
    category = input;
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS Home(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS Auto(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS Grocery(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS Savings(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS Entertainment(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE IF NOT EXISTS Bills(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      item TEXT,
      amount DOUBLE,
      budget DOUBLE,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

//Creates database
  static Future<sql.Database> db() async {
    final databasePath = await sql.getDatabasesPath();
    final path = join(databasePath, 'categories.db');
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

//How an item is created into database, using map calling format
  static Future<int> createItem(String item, double? amount) async {
    final db = await DatabaseHelper.db();

    final data = {'item': item, 'amount': amount};
    final id = await db.insert(
      category,
      data,
      //conflictAlgorithm: sql.ConflictAlgorithm.replace); supposed to prevent duplicate entry
    );
    return id;
  }

//Query to retreive data
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(category, orderBy: "id");
  }

//Retrieve single item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query(category, where: "id = ?", whereArgs: [id], limit: 1);
  }

//Edit/updates item
  static Future<int> updateItem(int id, String item, double? amount) async {
    final db = await DatabaseHelper.db();

    final data = {
      'item': item,
      'amount': amount,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update(category, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

//Deletes item
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete(category, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<List<Map<String, dynamic>>> calculateTotal(
      String category) async {
    final db = await DatabaseHelper.db();
    var total = await db.rawQuery('SELECT SUM(amount) AS TOTAL FROM $category');
    return total.toList();
  }

  static Future<int> setBudget(double budget) async {
    final db = await DatabaseHelper.db();
    final data = {'budget': budget};
    final id = db.update(category, data, where: "id = 1");
    return id;
  }

  static Future<int> updateBudget(double budget) async {
    final db = await DatabaseHelper.db();
    final data = {'budget': budget, 'createdAt': DateTime.now().toString()};

    final result = await db.update(category, data, where: "id = 1");
    return result;
  }

  static Future<List<Map<String, dynamic>>> getBudget() async {
    final db = await DatabaseHelper.db();
    return db.rawQuery('SELECT budget AS TOTAL FROM $category');
  }
}
