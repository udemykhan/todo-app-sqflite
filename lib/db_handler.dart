import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app_sqflite/model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'Todo.db');

    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE myTodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, dateAndTime TEXT NOT NULL)",
    );
  }

  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('myTodo', todoModel.toMap());
    return todoModel;
  }

  Future<List<TodoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> queryResult = await _db!.rawQuery('SELECT * FROM myTodo');
    return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('myTodo', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update('myTodo', todoModel.toMap(),where: 'id = ?', whereArgs: [todoModel.id]);
  }
}
