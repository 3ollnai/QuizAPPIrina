import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart'; 
import 'package:path_provider/path_provider.dart';
import '../models/scores.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'quiz_app.db'); 
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scores(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            score INTEGER,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertScore(Score score) async {
    final db = await database;
    await db.insert('scores', {
      'userId': score.userId,
      'score': score.score,
      'date': score.date.toIso8601String(),
    });
  }

  Future<List<Score>> getScoresByUserId(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Score(
        userId: maps[i]['userId'],
        score: maps[i]['score'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }
}
