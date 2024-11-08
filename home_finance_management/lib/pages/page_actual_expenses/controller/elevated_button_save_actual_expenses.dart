import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';
import 'package:http/http.dart' as http;
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/show_error_dialog_for_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/text_controller_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/actual_expense_selected_date.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_currency_actual_expenses.dart';

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
  final String apiKey = 'd3d37cccac2e9edeb3161e0f';
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/';

  Future<double> convertCurrency(String from, String to, double amount) async {
    final response = await http.get(Uri.parse('$apiUrl$from'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rate = data['rates'][to];
      return amount * rate;
    } else {
      throw Exception('Failed to load currency data');
    }
  }

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
          showErrorDialogForActualExpenses(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }

        double convertedSum;
        if (selectedCurrencyActualExpenses != 'RUB') {
          convertedSum = await convertCurrency(
            selectedCurrencyActualExpenses,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }

        final dbHelper = DatabaseHelper();
        final id = await dbHelper.insertActualExpenses({
          'date': actualExpensesSelectedDate.toIso8601String(),
          'sum': convertedSum,
          'category': selectedCategoryActualExpenses, // Добавляем категорию
        });

        final actualExpenses = ActualExpenses(
            idActualExpenses: id,
            dateActualExpenses: actualExpensesSelectedDate,
            sumActualExpenses: convertedSum,
            categoryActualExpenses: selectedCategoryActualExpenses); // Добавляем категорию
        listActualExpenses.add(actualExpenses);
        textControllerActualExpenses.clear();

        listActualExpenses.sort(
                (a, b) => a.dateActualExpenses.compareTo(b.dateActualExpenses));

        filterActualExpenses(() {});

        widget.updateActualExpenses();
      },
      child: const Text('Сохранить'),
    );
  }
}