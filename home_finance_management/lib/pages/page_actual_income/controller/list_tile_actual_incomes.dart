import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/components/show_error_dialog_for_actual_incomes.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/pages/page_actual_income/components/database_helper_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/components/text_button_cancel_alert_dialog_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/text_field_enter_for_actual_incomes.dart';

class ListTileActualIncomes extends StatefulWidget {
  final int index;
  final VoidCallback updateActualIncomes;

  const ListTileActualIncomes({
    super.key,
    required this.index,
    required this.updateActualIncomes,
  });

  @override
  State<ListTileActualIncomes> createState() => _ListTileActualIncomes(index);
}

class _ListTileActualIncomes extends State<ListTileActualIncomes> {
  final int index;
  DateTime? selectedDate;
  TextEditingController? sumControllerActualIncomes;

  _ListTileActualIncomes(this.index);

  @override
  void initState() {
    super.initState();
    sumControllerActualIncomes = TextEditingController(); // Инициализация sumController
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${filteredActualIncomesList[index].sumActualIncomes} рублей'),
      subtitle: Text(DateFormat('d.M.y').format(filteredActualIncomesList[index].dateActualIncomes)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              sumControllerActualIncomes?.text = filteredActualIncomesList[index].sumActualIncomes.toString();
              selectedDate = filteredActualIncomesList[index].dateActualIncomes;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Редактировать доход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldEnterForActualIncomes(
                            textControllerActualIncomes: sumControllerActualIncomes,
                            labelText: 'Введите доход',
                            keyboardType: TextInputType.number),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: filteredActualIncomesList[index].dateActualIncomes,
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
                      const TextButtonCancelAlertDialogForActualIncomes(
                        text: 'Отмена',
                      ),
                      TextButton(
                        onPressed: () async {
                          double sum;
                          try {
                            sum = double.parse(sumControllerActualIncomes!.text);
                          } catch (e) {
                            showErrorDialogForActualIncomes(context, 'Ошибка ввода',
                                'Пожалуйста, введите корректное числовое значение.');
                            return;
                          }

                          if (sumControllerActualIncomes!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final incomeIndex = listActualIncomes.indexWhere(
                                      (income) =>
                                  income.idActualIncomes == filteredActualIncomesList[index].idActualIncomes);
                              if (incomeIndex != -1) {
                                listActualIncomes[incomeIndex] = ActualIncomes(
                                    idActualIncomes: filteredActualIncomesList[index].idActualIncomes,
                                    dateActualIncomes: selectedDate!,
                                    sumActualIncomes: sum);

                                // Сортировка списка по дате
                                listActualIncomes
                                    .sort((a, b) => a.dateActualIncomes.compareTo(b.dateActualIncomes));

                                // Обновление фильтрованного списка
                                filterActualIncomes(widget.updateActualIncomes);

                                // Обновление базы данных
                                final dbHelper = DatabaseHelperForActualIncomes();
                                await dbHelper.updateActualIncome({
                                  'id': filteredActualIncomesList[index].idActualIncomes,
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
              final dbHelper = DatabaseHelperForActualIncomes();
              await dbHelper.deleteActualIncome(filteredActualIncomesList[index].idActualIncomes);
              listActualIncomes
                  .removeWhere((income) => income.idActualIncomes == filteredActualIncomesList[index].idActualIncomes);
              filterActualIncomes(widget.updateActualIncomes);
            },
          )
        ],
      ),
    );
  }
}
