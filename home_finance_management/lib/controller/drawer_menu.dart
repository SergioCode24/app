import 'package:flutter/material.dart';
import '../pages/page_actual_expenses/view_actual_expenses.dart';
import '../pages/page_actual_income/view_actual_income.dart';
import '../pages/page_history/view_history.dart';
import '../pages/page_planned_expenses/view_planned_expenses.dart';
import '../pages/page_planned_income/view_planned_income.dart';
import '../pages/page_statistics/view_statistics.dart';

class DrawerMenu extends StatelessWidget {
  final bool actualIncomePage;
  final bool actualExpensesPage;
  final bool plannedIncomePage;
  final bool plannedExpensesPage;
  final bool statisticsPage;
  final bool historyPage;

  const DrawerMenu(
      {super.key,
      required this.actualIncomePage,
      required this.actualExpensesPage,
      required this.plannedIncomePage,
      required this.plannedExpensesPage,
      required this.statisticsPage,
      required this.historyPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Меню',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text(
              'Фактические доходы',
            ),
            onTap: () {
              if (actualIncomePage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewActualIncome(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_down),
            title: const Text(
              'Фактические расходы',
            ),
            onTap: () {
              if (actualExpensesPage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewActualExpenses(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text(
              'Запланированные доходы',
            ),
            onTap: () {
              if (plannedIncomePage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewPlannedIncome(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text(
              'Запланированные расходы',
            ),
            onTap: () {
              if (plannedExpensesPage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewPlannedExpenses(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text(
              'Статистика',
            ),
            onTap: () {
              if (statisticsPage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewStatistics(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text(
              'История',
            ),
            onTap: () {
              if (historyPage == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewHistory(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
