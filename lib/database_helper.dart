import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database?> get database async {
    if (_database == null)
      _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status INTEGER)',
    );
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final Database? db = await instance.database;
    return await db!.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final Database? db = await instance.database;
    return await db!.query('tasks');
  }

  Future<List<Map<String, dynamic>>> getDoneTasks() async {
    final Database? db = await instance.database;
    return await db!.query('tasks', where: 'status = 1');
  }

  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    final Database? db = await instance.database;
    return await db!.query('tasks', where: 'status = 0');
  }

  // Future<int> updateTaskStatus(Map <String, dynamic> task) async{
  //   final Database? db = await instance.database;
  //   return await db!.update(
  //       'tasks',
  //       {status: });
  // }

}
