import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/text_controller_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/actual_income_selected_date.dart';

class ElevatedButtonSaveActualIncomes extends StatefulWidget {
  final VoidCallback updateActualIncomes;

  const ElevatedButtonSaveActualIncomes(
      {super.key, required this.updateActualIncomes});

  @override
  State<ElevatedButtonSaveActualIncomes> createState() =>
      _ElevatedButtonSaveActualIncomes();
}

class _ElevatedButtonSaveActualIncomes
    extends State<ElevatedButtonSaveActualIncomes> {
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
        if (textControllerActualIncomes.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerActualIncomes.text);
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
        await dbHelper.insertActualIncome({
          'date': actualIncomeSelectedDate.toIso8601String(),
          'sum': convertedSum,
        });
        textControllerActualIncomes.clear();
        listActualIncomes = await getActualIncomesFromDatabase();
        listActualIncomes
            .sort((a, b) => a.dateActualIncomes.compareTo(b.dateActualIncomes));
        filterActualIncomes(() {});
        widget.updateActualIncomes();
      },
      child: const Text(
        'Сохранить',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
