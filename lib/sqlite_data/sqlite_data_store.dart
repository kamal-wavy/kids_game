import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBStudentManager {
  Database? _database;

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "userData.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE userData(id INTEGER PRIMARY KEY AUTOINCREMENT,userNames TEXT,result TEXT)");
      });
    }
  }

  Future<int> insertStudent(UserData userData) async {
    await openDB();
    return await _database!.insert('userData', userData.toMap());
  }

  // Future<List<UserData>> getStudentList() async {
  //   await openDB();
  //   final List<Map<String, dynamic>> maps = await _database!.query('userData');
  //
  //   return List.generate(maps.length, (index) {
  //     return UserData(
  //         id: maps[index]['id'],
  //         userNames: maps[index]['userNames'],
  //         result: maps[index]['result']);
  //   });
  // }
  Future<List<UserData>> getStudentList() async {
    await openDB();

    final List<Map<String, dynamic>> maps = await _database!.rawQuery(
      'SELECT * FROM userData ORDER BY id DESC LIMIT 5',
    );

    return List.generate(maps.length, (index) {
      return UserData(
        id: maps[index]['id'],
        userNames: maps[index]['userNames'],
        result: maps[index]['result'],
      );
    });
  }

  Future<void> deleteExcessRecords() async {
    await openDB();

    // Get the IDs of the last 5 records
    final List<Map<String, dynamic>> lastFiveRecords = await _database!.rawQuery(
      'SELECT id FROM userData ORDER BY id DESC LIMIT 5',
    );

    // Extract the IDs from the result
    final List<int> idsToKeep = lastFiveRecords.map<int>((record) => record['id']).toList();

    // Delete records that are not in the list of IDs to keep
    await _database!.rawDelete(
      'DELETE FROM userData WHERE id NOT IN (${idsToKeep.join(', ')})',
    );
  }
  Future<int> updateStudent(UserData userData) async {
    await openDB();
    return await _database!.update('userData', userData.toMap(),
        where: 'id=?', whereArgs: [userData.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDB();
    await _database!.delete("userData", where: "id = ? ", whereArgs: [id]);
  }
}

class UserData {
  int? id;
  String? userNames;
  String? result;

  UserData({@required this.userNames, @required this.result, this.id});

  Map<String, dynamic> toMap() {
    return {'userNames': userNames, 'result': result};
  }
}
