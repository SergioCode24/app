import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:home_finance_management/pages/page_planned_income//model/list_incomes.dart';

class DatabaseHelperForPlannedIncomes {
  static final DatabaseHelperForPlannedIncomes instance = DatabaseHelperForPlannedIncomes.internal();

  factory DatabaseHelperForPlannedIncomes() => instance;

  DatabaseHelperForPlannedIncomes.internal();

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
          CREATE TABLE planned_incomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            sum REAL
          )
        ''');
      },
    );
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

Future<List<PlannedIncomes>> getPlannedIncomesFromDatabase() async {
  final dbHelper = DatabaseHelperForPlannedIncomes();
  final plannedIncomesListFromDB = await dbHelper.getPlannedIncomes();
  return plannedIncomesListFromDB.map((plannedIncomesFromDB) {
    return PlannedIncomes(
      id: plannedIncomesFromDB['id'],
      date: DateTime.parse(plannedIncomesFromDB['date']), // Преобразование строки в DateTime
      sum: plannedIncomesFromDB['sum'],
    );
  }).toList();
}
