import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/dropdown_button_category_in_dialog.dart';
import 'package:home_finance_management/component/text_button_cancel.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/model/selected_category.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filtered_actual_expenses_list.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/text_field_enter_for_actual_expenses.dart';

class ListTileActualExpenses extends StatefulWidget {
  final int index;
  final VoidCallback updateActualExpenses;

  const ListTileActualExpenses({
    super.key,
    required this.index,
    required this.updateActualExpenses,
  });

  @override
  State<ListTileActualExpenses> createState() => _ListTileActualExpensesState();
}

class _ListTileActualExpensesState extends State<ListTileActualExpenses> {
  DateTime? selectedDate;
  TextEditingController? sumControllerActualExpenses;

  void updateStateListTileActualExpenses() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sumControllerActualExpenses = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${filteredActualExpensesList[widget.index].sumActualExpenses} рублей',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Категория: ${filteredActualExpensesList[widget.index].categoryActualExpenses}',
          ),
          Text(DateFormat('d.M.y').format(
              filteredActualExpensesList[widget.index].dateActualExpenses)),
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
              sumControllerActualExpenses?.text =
                  filteredActualExpensesList[widget.index]
                      .sumActualExpenses
                      .toString();
              selectedDate =
                  filteredActualExpensesList[widget.index].dateActualExpenses;
              selectedCategory = filteredActualExpensesList[widget.index]
                  .categoryActualExpenses;
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
                              child: TextFieldEnterForActualExpenses(
                                  textControllerActualExpenses:
                                      sumControllerActualExpenses,
                                  labelText: 'Введите расход',
                                  keyboardType: TextInputType.number),
                            ),
                            const DropdownButtonCurrency()
                          ],
                        ),
                        DropdownButtonCategoryInDialog(
                            updateState: updateStateListTileActualExpenses),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  filteredActualExpensesList[widget.index]
                                      .dateActualExpenses,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
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
                            sum =
                                double.parse(sumControllerActualExpenses!.text);
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
                          if (sumControllerActualExpenses!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final actualExpensesIndex = listActualExpenses
                                  .indexWhere((actualExpense) =>
                                      actualExpense.idActualExpenses ==
                                      filteredActualExpensesList[widget.index]
                                          .idActualExpenses);
                              if (actualExpensesIndex != -1) {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.updateActualExpenses({
                                  'id': filteredActualExpensesList[widget.index]
                                      .idActualExpenses,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': double.parse(
                                      convertedSum.toStringAsFixed(2)),
                                  'category': selectedCategory,
                                });
                                listActualExpenses =
                                    await getActualExpensesFromDatabase();
                                listActualExpenses.sort((a, b) => a
                                    .dateActualExpenses
                                    .compareTo(b.dateActualExpenses));
                                filterActualExpenses(
                                    widget.updateActualExpenses);
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
              await dbHelper.deleteActualExpenses(
                  filteredActualExpensesList[widget.index].idActualExpenses);
              listActualExpenses = await getActualExpensesFromDatabase();
              filterActualExpenses(widget.updateActualExpenses);
            },
          )
        ],
      ),
    );
  }
}
