import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/planned_expense_selected_date.dart';

class ElevatedButtonSelectDatePlannedExpenses extends StatefulWidget {
  const ElevatedButtonSelectDatePlannedExpenses({super.key});

  @override
  State<ElevatedButtonSelectDatePlannedExpenses> createState() =>
      _ElevatedButtonSelectDatePlannedExpensesState();
}

class _ElevatedButtonSelectDatePlannedExpensesState
    extends State<ElevatedButtonSelectDatePlannedExpenses> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2124),
        );
        if (picked != null && picked != plannedExpensesSelectedDate) {
          setState(() {
            plannedExpensesSelectedDate = picked;
          });
        }
      },
      child: const Text('Выбрать дату'),
    );
  }
}
