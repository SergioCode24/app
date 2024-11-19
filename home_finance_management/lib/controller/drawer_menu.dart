import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/view_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_income/view_actual_income.dart';
import 'package:home_finance_management/pages/page_planned_expenses/view_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_income/view_planned_income.dart';

class DrawerMenu extends StatelessWidget {
  final bool actualIncomePage;
  final bool actualExpensesPage;
  final bool plannedIncomePage;
  final bool plannedExpensesPage;

  const DrawerMenu(
      {super.key,
      required this.actualIncomePage,
      required this.actualExpensesPage,
      required this.plannedIncomePage,
      required this.plannedExpensesPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Меню',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.trending_up,
              color: Colors.green,
            ),
            title: const Text(
              'Фактические доходы',
              style: TextStyle(color: Colors.white),
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
            leading: const Icon(
              Icons.trending_down,
              color: Colors.red,
            ),
            title: const Text(
              'Фактические расходы',
                style: TextStyle(color: Colors.white),
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
            leading: const Icon(
              Icons.schedule,
              color: Colors.green,
            ),
            title: const Text(
              'Запланированные доходы',
                style: TextStyle(color: Colors.white),
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
            leading: const Icon(
              Icons.schedule,
              color: Colors.red,
            ),
            title: const Text(
              'Запланированные расходы',
              style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
