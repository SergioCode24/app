import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:home_finance_management/pages/page_planned_income/components/database_helper_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/show_error_dialog_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/text_controller.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/selected_date.dart';

class ElevatedButtonSave extends StatefulWidget {
  final VoidCallback onSave;
  final String selectedCurrency;

  const ElevatedButtonSave(
      {super.key, required this.onSave, required this.selectedCurrency});

  @override
  State<ElevatedButtonSave> createState() => _ElevatedButtonSave();
}

class _ElevatedButtonSave extends State<ElevatedButtonSave> {
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
        if (textController.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textController.text);
        } catch (e) {
          showErrorDialogForPlannedIncomes(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }

        // Конвертация валюты
        double convertedSum;
        if (widget.selectedCurrency != 'RUB') {
          convertedSum = await convertCurrency(
            widget.selectedCurrency,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }

        final dbHelper = DatabaseHelperForPlannedIncomes();
        final id = await dbHelper.insertPlannedIncome({
          'date': actualIncomeSelectedDate.toIso8601String(),
          'sum': convertedSum,
        });

        final income =
            PlannedIncomes(id: id, date: actualIncomeSelectedDate, sum: convertedSum);
        listPlannedIncomes.add(income);
        textController.clear();

        // Сортировка списка по дате
        listPlannedIncomes.sort((a, b) => a.date.compareTo(b.date));

        // Обновление фильтрованного списка
        filterPlannedIncomes(() {});

        widget.onSave();
      },
      child: const Text('Сохранить'),
    );
  }
}
