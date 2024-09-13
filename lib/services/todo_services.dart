import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application/model/todo.dart';

class TodoService {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;

  static Database? _database;

  TodoService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE todos(
          id TEXT PRIMARY KEY, 
          title TEXT, 
          description TEXT, 
          isDone INTEGER DEFAULT 0
        )
        ''',
        );
      },
    );
  }

  Future<List<Todo>> fetchTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Todo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          isDone: maps[i]['isDone'] ==
              1, // SQLite stores bool as int (1 = true, 0 = false)
        );
      });
    } else {
      return [];
    }
  }

  Future<void> addTodo(Map<String, dynamic> todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Todo added locally.');
  }

  Future<void> deleteTodoById(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Todo with id $id deleted locally.');
  }

  Future<void> editTodo(
      String id, String newTitle, String newDescription, bool isDone) async {
    final db = await database;
    await db.update(
      'todos',
      {
        'title': newTitle,
        'description': newDescription,
        'isDone': isDone ? 1 : 0, // Store bool as integer (1 = true, 0 = false)
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Todo with id $id updated locally.');
  }
}
