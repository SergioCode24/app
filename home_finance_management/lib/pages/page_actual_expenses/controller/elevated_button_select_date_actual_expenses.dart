import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/actual_expense_selected_date.dart';

class ElevatedButtonSelectDateActualExpenses extends StatefulWidget {
  const ElevatedButtonSelectDateActualExpenses({super.key});

  @override
  State<ElevatedButtonSelectDateActualExpenses> createState() =>
      _ElevatedButtonSelectDateActualExpensesState();
}

class _ElevatedButtonSelectDateActualExpensesState
    extends State<ElevatedButtonSelectDateActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != actualExpensesSelectedDate) {
          setState(() {
            actualExpensesSelectedDate = picked;
          });
        }
      },
      child: const Text('Выбрать дату'),
    );
  }
}
