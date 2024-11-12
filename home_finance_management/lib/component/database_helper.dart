import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();

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
      version: 7,
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
        await db.execute('''
      CREATE TABLE actual_expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        sum REAL,
        category TEXT
      )
    ''');
        await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 7) {
          await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
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

  Future<int> insertActualExpenses(Map<String, dynamic> actualExpenses) async {
    final db = await database;
    return await db!.insert('actual_expenses', actualExpenses);
  }

  Future<List<Map<String, dynamic>>> getActualExpenses() async {
    final db = await database;
    return await db!.query('actual_expenses');
  }

  Future<void> updateActualExpenses(Map<String, dynamic> actualExpenses) async {
    final db = await database;
    await db!.update(
      'actual_expenses',
      actualExpenses,
      where: 'id = ?',
      whereArgs: [actualExpenses['id']],
    );
  }

  Future<void> deleteActualExpenses(int id) async {
    final db = await database;
    await db!.delete(
      'actual_expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearActualExpenses() async {
    final db = await database;
    await db!.delete('actual_expenses');
  }

  Future<int> insertCategories(
      Map<String, dynamic> categories) async {
    final db = await database;
    return await db!
        .insert('categories', categories);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db!.query('categories');
  }

  Future<void> clearCategories() async {
    final db = await database;
    final defaultCategories = [
      'Автомобиль',
      'Общественный транспорт',
      'Дом',
      'Здоровье',
      'Личные расходы',
      'Одежда',
      'Питание',
      'Подарки',
      'Семейные расходы',
      'Техника',
      'Услуги',
      'Другое'
    ];

    final currentCategories = await getCategories();
    final categoriesToSave = currentCategories
        .where((category) => !defaultCategories.contains(category['name']))
        .map((category) => category['name'])
        .toList();

    for (var category in categoriesToSave) {
      await insertCategories({'name': category});
    }

    for (var category in categoriesToSave) {
      await updateCategory(category, 'Другое');
    }

    await db!.delete('categories');
    for (var category in defaultCategories) {
      await insertCategories({'name': category});
    }
  }

  Future<bool> categoryExists(
      String categoryName) async {
    final db = await database;
    final result = await db!.query(
      'categories',
      where: 'name = ?',
      whereArgs: [categoryName],
    );
    return result.isNotEmpty;
  }

  Future<void> updateCategory(String oldCategory, String newCategory) async {
    final db = await database;
    await db!.update(
      'actual_expenses',
      {'category': newCategory},
      where: 'category = ?',
      whereArgs: [oldCategory],
    );
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

Future<List<ActualExpenses>> getActualExpensesFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final actualExpensesListFromDB = await dbHelper.getActualExpenses();
  return actualExpensesListFromDB.map((actualExpensesFromDB) {
    return ActualExpenses(
      idActualExpenses: actualExpensesFromDB['id'],
      dateActualExpenses: DateTime.parse(actualExpensesFromDB['date']),
      sumActualExpenses: actualExpensesFromDB['sum'],
      categoryActualExpenses: actualExpensesFromDB['category'],
    );
  }).toList();
}

Future<List<String>> getCategoriesFromDatabase() async {
  final dbHelper = DatabaseHelper();
  final categoriesListFromDB =
      await dbHelper.getCategories();
  return categoriesListFromDB.map((categoryFromDB) {
    return categoryFromDB['name'].toString();
  }).toList();
}
