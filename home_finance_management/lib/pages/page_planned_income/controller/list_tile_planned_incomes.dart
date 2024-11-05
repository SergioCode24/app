import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_planned_income/components/show_error_dialog_for_planned_incomes.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_planned_incomes_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/text_button_cancel_alert_dialog_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/text_field_enter_for_planned_incomes.dart';

class ListTilePlannedIncomes extends StatefulWidget {
  final int index;
  final VoidCallback updatePlannedIncomes;

  const ListTilePlannedIncomes({
    super.key,
    required this.index,
    required this.updatePlannedIncomes,
  });

  @override
  State<ListTilePlannedIncomes> createState() => _ListTilePlannedIncomesState();
}

class _ListTilePlannedIncomesState extends State<ListTilePlannedIncomes> {
  DateTime? selectedDate;
  TextEditingController? sumControllerPlannedIncomes;

  @override
  void initState() {
    super.initState();
    sumControllerPlannedIncomes = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          '${filteredPlannedIncomesList[widget.index].sumPlannedIncomes} рублей'),
      subtitle: Text(DateFormat('d.M.y')
          .format(filteredPlannedIncomesList[widget.index].datePlannedIncomes)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              sumControllerPlannedIncomes?.text =
                  filteredPlannedIncomesList[widget.index]
                      .sumPlannedIncomes
                      .toString();
              selectedDate =
                  filteredPlannedIncomesList[widget.index].datePlannedIncomes;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Редактировать доход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldEnterForPlannedIncomes(
                            textControllerPlannedIncomes:
                                sumControllerPlannedIncomes,
                            labelText: 'Введите доход',
                            keyboardType: TextInputType.number),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  filteredPlannedIncomesList[widget.index]
                                      .datePlannedIncomes,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2124),
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
                            sum =
                                double.parse(sumControllerPlannedIncomes!.text);
                          } catch (e) {
                            showErrorDialogForPlannedIncomes(
                                context,
                                'Ошибка ввода',
                                'Пожалуйста, введите корректное числовое значение.');
                            return;
                          }

                          if (sumControllerPlannedIncomes!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final plannedIncomeIndex = listPlannedIncomes
                                  .indexWhere((plannedIncome) =>
                                      plannedIncome.idPlannedIncomes ==
                                      filteredPlannedIncomesList[widget.index]
                                          .idPlannedIncomes);
                              if (plannedIncomeIndex != -1) {
                                listPlannedIncomes[plannedIncomeIndex] =
                                    PlannedIncomes(
                                        idPlannedIncomes:
                                            filteredPlannedIncomesList[
                                                    widget.index]
                                                .idPlannedIncomes,
                                        datePlannedIncomes: selectedDate!,
                                        sumPlannedIncomes: sum);

                                listPlannedIncomes.sort((a, b) => a
                                    .datePlannedIncomes
                                    .compareTo(b.datePlannedIncomes));

                                filterPlannedIncomes(
                                    widget.updatePlannedIncomes);

                                final dbHelper = DatabaseHelper();
                                await dbHelper.updatePlannedIncome({
                                  'id': filteredPlannedIncomesList[widget.index]
                                      .idPlannedIncomes,
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
              final dbHelper = DatabaseHelper();
              await dbHelper.deletePlannedIncome(
                  filteredPlannedIncomesList[widget.index].idPlannedIncomes);
              listPlannedIncomes.removeWhere((plannedIncome) =>
                  plannedIncome.idPlannedIncomes ==
                  filteredPlannedIncomesList[widget.index].idPlannedIncomes);
              filterPlannedIncomes(widget.updatePlannedIncomes);
            },
          )
        ],
      ),
    );
  }
}
