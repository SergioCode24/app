import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/model/selected_category.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_planned_expenses/components/filter_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/text_controller_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/list_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/planned_expense_selected_date.dart';

class ElevatedButtonSavePlannedExpenses extends StatefulWidget {
  final VoidCallback updatePlannedExpenses;

  const ElevatedButtonSavePlannedExpenses(
      {super.key, required this.updatePlannedExpenses});

  @override
  State<ElevatedButtonSavePlannedExpenses> createState() =>
      _ElevatedButtonSavePlannedExpensesState();
}

class _ElevatedButtonSavePlannedExpensesState
    extends State<ElevatedButtonSavePlannedExpenses> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (textControllerPlannedExpenses.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerPlannedExpenses.text);
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
        await dbHelper.insertPlannedExpenses({
          'date': plannedExpensesSelectedDate.toIso8601String(),
          'sum': convertedSum,
          'category': selectedCategory,
        });
        textControllerPlannedExpenses.clear();
        listPlannedExpenses = await getPlannedExpensesFromDatabase();
        listPlannedExpenses.sort(
            (a, b) => a.datePlannedExpenses.compareTo(b.datePlannedExpenses));
        filterPlannedExpenses(() {});
        widget.updatePlannedExpenses();
      },
      child: const Text('Сохранить'),
    );
  }
}
