import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_income/view_actual_income.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Управление домашними финансами',
      home: ViewActualIncome(),
    );
  }
}
