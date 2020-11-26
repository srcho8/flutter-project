import 'dart:io';

import 'package:flutter_app_project1/model/memo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String TableName = 'Memo';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MemoL.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            contents TEXT,
            imageurl TEXT,
            datetime TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(Memo memo) async {
    final db = await database;
    var res = await db.insert(TableName, memo.toJson());
    return res;
  }

  //Read
  getMemo(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty
        ? Memo(id: res.first['id'], title: res.first['title'])
        : Null;
  }

  //Read All
  Future<List<Memo>> getAllMemos() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Memo> list = res.isNotEmpty
        ? res.map((c) => Memo(id: c['id'], title: c['title'], contents: c['contents'],imageurl: c['imageurl'],datetime: c['datetime'])).toList()
        : [];

    return list;
  }

  //Delete
  deleteMemo(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllMemos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

  //Update
  updateMemo(Memo memo) async {
    final db = await database;
    var res = db.rawUpdate('UPDATE $TableName SET title = ?, contents = ? WHERE id = ?', [memo.title, memo.contents, memo.id]);
    return res;
  }
}
