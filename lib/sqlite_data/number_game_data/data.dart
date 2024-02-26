import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBNumberGame {
  Database? _database;

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "numberUserData.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE numberUserData(id INTEGER PRIMARY KEY AUTOINCREMENT,userNames TEXT,result TEXT,userMoves TEXT)");
      });
    }
  }

  Future<int> insertStudent(NumberUserData userData) async {
    await openDB();
    return await _database!.insert('numberUserData', userData.toMap());
  }

  // Future<List<NumberUserData>> getStudentList() async {
  //   await openDB();
  //   final List<Map<String, dynamic>> maps = await _datebase!.query('numberUserData');
  //
  //   return List.generate(maps.length, (index) {
  //     return NumberUserData(
  //         id: maps[index]['id'],
  //         userNames: maps[index]['userNames'],
  //         result: maps[index]['result'],
  //         userMoves: maps[index]['userMoves']
  //     );
  //   });
  // }
  Future<List<NumberUserData>> getStudentList() async {
    await openDB();

    final List<Map<String, dynamic>> maps = await _database!.rawQuery(
      'SELECT * FROM numberUserData ORDER BY id DESC LIMIT 5',
    );

    return List.generate(maps.length, (index) {
      return NumberUserData(
        id: maps[index]['id'],
        userNames: maps[index]['userNames'],
        result: maps[index]['result'],
          userMoves: maps[index]['userMoves']
      );
    });
  }

  Future<void> deleteExcessRecords() async {
    await openDB();

    // Get the IDs of the last 5 records
    final List<Map<String, dynamic>> lastFiveRecords = await _database!.rawQuery(
      'SELECT id FROM numberUserData ORDER BY id DESC LIMIT 5',
    );

    // Extract the IDs from the result
    final List<int> idsToKeep = lastFiveRecords.map<int>((record) => record['id']).toList();

    // Delete records that are not in the list of IDs to keep
    await _database!.rawDelete(
      'DELETE FROM numberUserData WHERE id NOT IN (${idsToKeep.join(', ')})',
    );
  }
  Future<int> updateStudent(NumberUserData userData) async {
    await openDB();
    return await _database!.update('numberUserData', userData.toMap(),
        where: 'id=?', whereArgs: [userData.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDB();
    await _database!.delete("userData", where: "id = ? ", whereArgs: [id]);
  }
}

class NumberUserData {
  int? id;
  String? userNames;
  String? result;
  String? userMoves;

  NumberUserData({@required this.userNames, @required this.result, this.id,this.userMoves});

  Map<String, dynamic> toMap() {
    return {'userNames': userNames, 'result': result,'userMoves':userMoves};
  }
}
