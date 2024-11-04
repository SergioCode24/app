import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

class DatabaseHelperForActualIncomes {
  static final DatabaseHelperForActualIncomes instance = DatabaseHelperForActualIncomes.internal();

  factory DatabaseHelperForActualIncomes() => instance;

  DatabaseHelperForActualIncomes.internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'finance_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE actual_incomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            sum REAL
          )
        ''');
      },
    );
  }

  Future<int> insertActualIncome(Map<String, dynamic> actualIncome) async {
    final db = await database;
    return await db!.insert('actual_incomes', actualIncome);
  }

  Future<List<Map<String, dynamic>>> getActualIncomes() async {
    final db = await database;
    return await db!.query('actual_incomes');
  }

  Future<void> updateActualIncome(Map<String, dynamic> actualIncome) async {
    final db = await database;
    await db!.update(
      'actual_incomes',
      actualIncome,
      where: 'id = ?',
      whereArgs: [actualIncome['id']],
    );
  }

  Future<void> deleteActualIncome(int id) async {
    final db = await database;
    await db!.delete(
      'actual_incomes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearActualIncomes() async {
    final db = await database;
    await db!.delete('actual_incomes');
  }
}

Future<List<ActualIncomes>> getActualIncomesFromDatabase() async {
  final dbHelper = DatabaseHelperForActualIncomes();
  final actualIncomesListFromDB = await dbHelper.getActualIncomes();
  return actualIncomesListFromDB.map((actualIncomesFromDB) {
    return ActualIncomes(
      idActualIncomes: actualIncomesFromDB['id'],
      dateActualIncomes: DateTime.parse(actualIncomesFromDB['date']), // Преобразование строки в DateTime
      sumActualIncomes: actualIncomesFromDB['sum'],
    );
  }).toList();
}
