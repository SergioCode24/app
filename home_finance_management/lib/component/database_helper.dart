import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper.internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper.internal();

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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE actual_incomes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          sum REAL
        )
      ''');
        await db.execute('''
        CREATE TABLE planned_incomes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          sum REAL
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE planned_incomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            sum REAL
          )
        ''');
        }
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

  Future<int> insertPlannedIncome(Map<String, dynamic> plannedIncome) async {
    final db = await database;
    return await db!.insert('planned_incomes', plannedIncome);
  }

  Future<List<Map<String, dynamic>>> getPlannedIncomes() async {
    final db = await database;
    return await db!.query('planned_incomes');
  }

  Future<void> updatePlannedIncome(Map<String, dynamic> plannedIncome) async {
    final db = await database;
    await db!.update(
      'planned_incomes',
      plannedIncome,
      where: 'id = ?',
      whereArgs: [plannedIncome['id']],
    );
  }

  Future<void> deletePlannedIncome(int id) async {
    final db = await database;
    await db!.delete(
      'planned_incomes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearPlannedIncomes() async {
    final db = await database;
    await db!.delete('planned_incomes');
  }

}

Future<List<ActualIncomes>> getActualIncomesFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final actualIncomesListFromDB = await dbHelper.getActualIncomes();
  return actualIncomesListFromDB.map((actualIncomesFromDB) {
    return ActualIncomes(
      idActualIncomes: actualIncomesFromDB['id'],
      dateActualIncomes: DateTime.parse(actualIncomesFromDB['date']),
      sumActualIncomes: actualIncomesFromDB['sum'],
    );
  }).toList();
}

Future<List<PlannedIncomes>> getPlannedIncomesFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final plannedIncomesListFromDB = await dbHelper.getPlannedIncomes();
  return plannedIncomesListFromDB.map((plannedIncomesFromDB) {
    return PlannedIncomes(
      idPlannedIncomes: plannedIncomesFromDB['id'],
      datePlannedIncomes: DateTime.parse(plannedIncomesFromDB['date']),
      sumPlannedIncomes: plannedIncomesFromDB['sum'],
    );
  }).toList();
}
