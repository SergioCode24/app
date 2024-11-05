import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_statistics/view_statistics.dart';
import 'pages/page_actual_income/components/database_helper_for_actual_incomes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelperForActualIncomes().database;
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
      home: ViewStatistics(),
    );
  }
}
