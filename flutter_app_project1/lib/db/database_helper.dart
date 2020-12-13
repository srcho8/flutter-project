import 'dart:io';

import 'package:InsFire/model/memo.dart';
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
    String path = join(documentsDirectory.path, 'Memo3.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            contents TEXT,
            original TEXT,
            large2x TEXT,
            large TEXT,
            medium TEXT,
            small TEXT,
            portrait TEXT,
            landscape TEXT,
            tiny TEXT,
            datetime TEXT,
            selected INTEGER
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
  Future<Memo> getMemo(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty
        ? Memo(
            id: res.first['id'],
            title: res.first['title'],
            contents: res.first['contents'],
            original: res.first['original'],
            large2x: res.first['large2x'],
            large: res.first['large'],
            medium: res.first['medium'],
            small: res.first['small'],
            portrait: res.first['portrait'],
            landscape: res.first['landscape'],
            tiny: res.first['tiny'],
            datetime: res.first['datetime'],
            selected: res.first['selected'])
        : Null;
  }

  getMemoWithtitle(String title) async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT * FROM $TableName WHERE title = ?", [title]);
    return res.isNotEmpty
        ? Memo(id: res.first['id'], title: res.first['title'])
        : Null;
  }

  //Read All
  Future<List<Memo>> getAllMemos() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Memo> list = res.isNotEmpty
        ? res
            .map((c) => Memo(
                id: c['id'],
                title: c['title'],
                contents: c['contents'],
                original: c['original'],
                large2x: c['large2x'],
                large: c['large'],
                medium: c['medium'],
                small: c['small'],
                portrait: c['portrait'],
                landscape: c['landscape'],
                tiny: c['tiny'],
                datetime: c['datetime'],
                selected: c['selected']))
            .toList()
        : [];

    return list;
  }

  //Delete
  deleteMemo(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  Future<List<Memo>> deleteMemoFuture(int id) async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Memo> list = res.isNotEmpty
        ? res
            .map((c) => Memo(
                id: c['id'],
                title: c['title'],
                contents: c['contents'],
                original: c['original'],
                large2x: c['large2x'],
                large: c['large'],
                medium: c['medium'],
                small: c['small'],
                portrait: c['portrait'],
                landscape: c['landscape'],
                tiny: c['tiny'],
                datetime: c['datetime'],
                selected: c['selected']))
            .toList()
        : [];
    return list;
  }

  //Delete All
  deleteAllMemos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

  //Delete
  deleteSelectedMemos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName WHERE selected = 1');
  }

  //Update
  updateMemo(Memo memo) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET title = ?, contents = ? WHERE id = ?',
        [memo.title, memo.contents, memo.id]);
    return res;
  }

  //Update
  updateSelectedMemo(int state, int id) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET selected = ? WHERE id = ?', [state, id]);
    return res;
  }

  //Update
  updateSelectedAllMemo() async {
    final db = await database;
    var res = db.rawUpdate('UPDATE $TableName SET selected = 1');
    return res;
  }

  updateSelectedAllMemo_2() async {
    final db = await database;
    var res = db.rawUpdate('UPDATE $TableName SET selected = 0');
    return res;
  }

  Stream<List<Memo>> getAllMemosStream() async* {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Memo> list = res.isNotEmpty
        ? res
            .map((c) => Memo(
                id: c['id'],
                title: c['title'],
                contents: c['contents'],
                original: c['original'],
                large2x: c['large2x'],
                large: c['large'],
                medium: c['medium'],
                small: c['small'],
                portrait: c['portrait'],
                landscape: c['landscape'],
                tiny: c['tiny'],
                datetime: c['datetime'],
                selected: c['selected']))
            .toList()
        : [];

    yield list;
  }
}
