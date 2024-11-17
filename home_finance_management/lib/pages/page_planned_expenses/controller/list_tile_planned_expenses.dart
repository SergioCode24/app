import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/dropdown_button_category_in_dialog.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/component/text_button_cancel.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:home_finance_management/model/selected_category.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/filtered_planned_expenses_list.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/list_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/components/filter_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/text_field_enter_for_planned_expenses.dart';

class ListTilePlannedExpenses extends StatefulWidget {
  final int index;
  final VoidCallback updatePlannedExpenses;

  const ListTilePlannedExpenses({
    super.key,
    required this.index,
    required this.updatePlannedExpenses,
  });

  @override
  State<ListTilePlannedExpenses> createState() =>
      _ListTilePlannedExpensesState();
}

class _ListTilePlannedExpensesState extends State<ListTilePlannedExpenses> {
  DateTime? selectedDate;
  TextEditingController? sumControllerPlannedExpenses;

  void updateStateListTilePlannedExpenses() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sumControllerPlannedExpenses = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          '${filteredPlannedExpensesList[widget.index].sumPlannedExpenses} рублей'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Категория: ${filteredPlannedExpensesList[widget.index].categoryPlannedExpenses}'),
          Text(DateFormat('d.M.y').format(
              filteredPlannedExpensesList[widget.index].datePlannedExpenses)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              String tempSelectedCurrency = selectedCurrency;
              selectedCurrency = 'RUB';
              sumControllerPlannedExpenses?.text =
                  filteredPlannedExpensesList[widget.index]
                      .sumPlannedExpenses
                      .toString();
              selectedDate =
                  filteredPlannedExpensesList[widget.index].datePlannedExpenses;
              selectedCategory = filteredPlannedExpensesList[widget.index]
                  .categoryPlannedExpenses;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Редактировать расход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldEnterForPlannedExpenses(
                                  textControllerPlannedExpenses:
                                      sumControllerPlannedExpenses,
                                  labelText: 'Введите расход',
                                  keyboardType: TextInputType.number),
                            ),
                            const DropdownButtonCurrency()
                          ],
                        ),
                        DropdownButtonCategoryInDialog(
                            updateState: updateStateListTilePlannedExpenses),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  filteredPlannedExpensesList[widget.index]
                                      .datePlannedExpenses,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2124),
                            );
                            if (picked != null) {
                              selectedDate = picked;
                            }
                          },
                          child: const Text('Выбрать дату'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButtonCancel(
                          tempSelectedCurrency: tempSelectedCurrency),
                      TextButton(
                        onPressed: () async {
                          double sum;
                          try {
                            sum = double.parse(
                                sumControllerPlannedExpenses!.text);
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
                          if (sumControllerPlannedExpenses!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final plannedExpensesIndex = listPlannedExpenses
                                  .indexWhere((plannedExpenses) =>
                                      plannedExpenses.idPlannedExpenses ==
                                      filteredPlannedExpensesList[widget.index]
                                          .idPlannedExpenses);
                              if (plannedExpensesIndex != -1) {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.updatePlannedExpenses({
                                  'id':
                                      filteredPlannedExpensesList[widget.index]
                                          .idPlannedExpenses,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': double.parse(
                                      convertedSum.toStringAsFixed(2)),
                                  'category': selectedCategory,
                                });
                                listPlannedExpenses =
                                    await getPlannedExpensesFromDatabase();
                                listPlannedExpenses.sort((a, b) => a
                                    .datePlannedExpenses
                                    .compareTo(b.datePlannedExpenses));
                                filterPlannedExpenses(
                                    widget.updatePlannedExpenses);
                              }
                            }
                          }
                          final currentContext = context;
                          if (mounted && currentContext.mounted) {
                            Navigator.of(currentContext).pop();
                          }
                          selectedCurrency = tempSelectedCurrency;
                        },
                        child: const Text('Сохранить'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final dbHelper = DatabaseHelper();
              await dbHelper.deletePlannedExpenses(
                  filteredPlannedExpensesList[widget.index].idPlannedExpenses);
              listPlannedExpenses = await getPlannedExpensesFromDatabase();
              filterPlannedExpenses(widget.updatePlannedExpenses);
            },
          )
        ],
      ),
    );
  }
}
