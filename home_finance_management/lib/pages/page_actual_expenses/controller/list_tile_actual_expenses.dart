import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/dropdown_button_category_for_actual_expenses_in_dialog.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/show_error_dialog_for_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filtered_actual_expenses_list.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/text_button_cancel_alert_dialog_for_actual_expenses.dart';
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
          '${filteredActualExpensesList[widget.index].sumActualExpenses} рублей'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Категория: ${filteredActualExpensesList[widget.index].categoryActualExpenses}'),
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
              sumControllerActualExpenses?.text =
                  filteredActualExpensesList[widget.index]
                      .sumActualExpenses
                      .toString();
              selectedDate =
                  filteredActualExpensesList[widget.index].dateActualExpenses;
              selectedCategoryActualExpenses =
                  filteredActualExpensesList[widget.index].categoryActualExpenses;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Редактировать расход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldEnterForActualExpenses(
                            textControllerActualExpenses:
                            sumControllerActualExpenses,
                            labelText: 'Введите расход',
                            keyboardType: TextInputType.number),
                        DropdownButtonCategoryForActualExpensesInDialog(
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
                      const TextButtonCancelAlertDialogForActualExpenses(
                        text: 'Отмена',
                      ),
                      TextButton(
                        onPressed: () async {
                          double sum;
                          try {
                            sum =
                                double.parse(sumControllerActualExpenses!.text);
                          } catch (e) {
                            showErrorDialogForActualExpenses(
                                context,
                                'Ошибка ввода',
                                'Пожалуйста, введите корректное числовое значение.');
                            return;
                          }

                          if (sumControllerActualExpenses!.text.isNotEmpty &&
                              selectedDate != null &&
                              selectedCategoryActualExpenses != 'Другое') {
                            {
                              final actualExpensesIndex = listActualExpenses
                                  .indexWhere((actualExpense) =>
                              actualExpense.idActualExpenses ==
                                  filteredActualExpensesList[widget.index]
                                      .idActualExpenses);
                              if (actualExpensesIndex != -1) {
                                listActualExpenses[actualExpensesIndex] =
                                    ActualExpenses(
                                        idActualExpenses:
                                        filteredActualExpensesList[
                                        widget.index]
                                            .idActualExpenses,
                                        dateActualExpenses: selectedDate!,
                                        sumActualExpenses: sum,
                                        categoryActualExpenses:
                                        selectedCategoryActualExpenses);

                                listActualExpenses.sort((a, b) => a
                                    .dateActualExpenses
                                    .compareTo(b.dateActualExpenses));

                                filterActualExpenses(
                                    widget.updateActualExpenses);

                                final dbHelper = DatabaseHelper();
                                await dbHelper.updateActualExpenses({
                                  'id': filteredActualExpensesList[widget.index]
                                      .idActualExpenses,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': sum,
                                  'category': selectedCategoryActualExpenses,
                                });
                              }
                            }
                          }
                          Navigator.of(context).pop();
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
              listActualExpenses.removeWhere((actualExpenses) =>
              actualExpenses.idActualExpenses ==
                  filteredActualExpensesList[widget.index].idActualExpenses);
              filterActualExpenses(widget.updateActualExpenses);
            },
          )
        ],
      ),
    );
  }
}
