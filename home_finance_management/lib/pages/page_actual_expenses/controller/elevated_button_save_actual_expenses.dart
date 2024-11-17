import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/model/selected_category.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/text_controller_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/actual_expense_selected_date.dart';
import 'package:home_finance_management/model/selected_currency.dart';

class ElevatedButtonSaveActualExpenses extends StatefulWidget {
  final VoidCallback updateActualExpenses;

  const ElevatedButtonSaveActualExpenses(
      {super.key, required this.updateActualExpenses});

  @override
  State<ElevatedButtonSaveActualExpenses> createState() =>
      _ElevatedButtonSaveActualExpensesState();
}

class _ElevatedButtonSaveActualExpensesState
    extends State<ElevatedButtonSaveActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (textControllerActualExpenses.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerActualExpenses.text);
        } catch (e) {
          showErrorDialog(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }
        double convertedSum;
        if (selectedCurrency != 'RUB') {
          convertedSum = await convertCurrency(
            selectedCurrency,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }
        final dbHelper = DatabaseHelper();
        await dbHelper.insertActualExpenses({
          'date': actualExpensesSelectedDate.toIso8601String(),
          'sum': convertedSum,
          'category': selectedCategory,
        });
        listActualExpenses = await getActualExpensesFromDatabase();
        listActualExpenses.sort(
            (a, b) => a.dateActualExpenses.compareTo(b.dateActualExpenses));
        textControllerActualExpenses.clear();
        filterActualExpenses(() {});
        widget.updateActualExpenses();
      },
      child: const Text('Сохранить'),
    );
  }
}
