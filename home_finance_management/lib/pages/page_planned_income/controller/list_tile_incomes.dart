import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/components/show_error_dialog_for_actual_incomes.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/pages/page_planned_income/components/database_helper_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/text_button_cancel_alert_dialog_for_planned_incomes.dart';
import 'text_field_enter.dart';

class ListTileIncomes extends StatefulWidget {
  final int index;
  final VoidCallback onSave;

  const ListTileIncomes({
    super.key,
    required this.index,
    required this.onSave,
  });

  @override
  State<ListTileIncomes> createState() => _ListTileIncomes(index);
}

class _ListTileIncomes extends State<ListTileIncomes> {
  final int index;
  DateTime? selectedDate;
  TextEditingController? sumController;

  _ListTileIncomes(this.index);

  @override
  void initState() {
    super.initState();
    sumController = TextEditingController(); // Инициализация sumController
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${filteredPlannedIncomesList[index].sum} рублей'),
      subtitle: Text(DateFormat('d.M.y').format(filteredPlannedIncomesList[index].date)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              sumController?.text = filteredPlannedIncomesList[index].sum.toString();
              selectedDate = filteredPlannedIncomesList[index].date;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Редактировать доход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldEnter(
                            controller: sumController,
                            labelText: 'Введите доход',
                            keyboardType: TextInputType.number),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: filteredPlannedIncomesList[index].date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              selectedDate = picked;
                            }
                          },
                          child: const Text('Выбрать дату'),
                        )
                      ],
                    ),
                    actions: [
                      const TextButtonCancelAlertDialogForPlannedIncomes(
                        text: 'Отмена',
                      ),
                      TextButton(
                        onPressed: () async {
                          double sum;
                          try {
                            sum = double.parse(sumController!.text);
                          } catch (e) {
                            showErrorDialogForActualIncomes(context, 'Ошибка ввода',
                                'Пожалуйста, введите корректное числовое значение.');
                            return;
                          }

                          if (sumController!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final incomeIndex = listPlannedIncomes.indexWhere(
                                      (income) =>
                                  income.id == filteredPlannedIncomesList[index].id);
                              if (incomeIndex != -1) {
                                listPlannedIncomes[incomeIndex] = PlannedIncomes(
                                    id: filteredPlannedIncomesList[index].id,
                                    date: selectedDate!,
                                    sum: sum);

                                // Сортировка списка по дате
                                listPlannedIncomes
                                    .sort((a, b) => a.date.compareTo(b.date));

                                // Обновление фильтрованного списка
                                filterPlannedIncomes(widget.onSave);

                                // Обновление базы данных
                                final dbHelper = DatabaseHelperForPlannedIncomes();
                                await dbHelper.updatePlannedIncome({
                                  'id': filteredPlannedIncomesList[index].id,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': sum,
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
              final dbHelper = DatabaseHelperForPlannedIncomes();
              await dbHelper.deletePlannedIncome(filteredPlannedIncomesList[index].id);
              listPlannedIncomes
                  .removeWhere((income) => income.id == filteredPlannedIncomesList[index].id);
              filterPlannedIncomes(widget.onSave);
            },
          )
        ],
      ),
    );
  }
}
