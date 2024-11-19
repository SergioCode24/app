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
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white24),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.white),
          ),
        ),
      ),
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          locale: const Locale('ru'),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.dark(),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != actualExpensesSelectedDate) {
          setState(() {
            actualExpensesSelectedDate = picked;
          });
        }
      },
      child: const Text(
        'Выбрать дату',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
