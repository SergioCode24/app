import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/component/text_button_cancel.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_planned_incomes_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
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
        '${filteredPlannedIncomesList[widget.index].sumPlannedIncomes} рублей',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        DateFormat('d.M.y').format(
            filteredPlannedIncomesList[widget.index].datePlannedIncomes),
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              String tempSelectedCurrency = selectedCurrency;
              selectedCurrency = 'RUB';
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
                    backgroundColor: Colors.white12,
                    title: const Text(
                      'Редактировать доход',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldEnterForPlannedIncomes(
                                  textControllerPlannedIncomes:
                                      sumControllerPlannedIncomes,),
                            ),
                            const DropdownButtonCurrency()
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            const WidgetStatePropertyAll(Colors.white24),
                            shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  filteredPlannedIncomesList[widget.index]
                                      .datePlannedIncomes,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2124),
                              locale: const Locale('ru'),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.dark(),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              selectedDate = picked;
                            }
                          },
                          child: const Text(
                            'Выбрать дату',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
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
                                double.parse(sumControllerPlannedIncomes!.text);
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
                          if (sumControllerPlannedIncomes!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final plannedIncomeIndex = listPlannedIncomes
                                  .indexWhere((plannedIncome) =>
                                      plannedIncome.idPlannedIncomes ==
                                      filteredPlannedIncomesList[widget.index]
                                          .idPlannedIncomes);
                              if (plannedIncomeIndex != -1) {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.updatePlannedIncome({
                                  'id': filteredPlannedIncomesList[widget.index]
                                      .idPlannedIncomes,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': double.parse(
                                      convertedSum.toStringAsFixed(2)),
                                });
                                listPlannedIncomes =
                                    await getPlannedIncomesFromDatabase();
                                listPlannedIncomes.sort((a, b) => a
                                    .datePlannedIncomes
                                    .compareTo(b.datePlannedIncomes));
                                filterPlannedIncomes(
                                    widget.updatePlannedIncomes);
                              }
                            }
                          }
                          final currentContext = context;
                          if (mounted && currentContext.mounted) {
                            Navigator.of(currentContext).pop();
                          }
                          selectedCurrency = tempSelectedCurrency;
                        },
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              final dbHelper = DatabaseHelper();
              await dbHelper.deletePlannedIncome(
                  filteredPlannedIncomesList[widget.index].idPlannedIncomes);
              listPlannedIncomes = await getPlannedIncomesFromDatabase();
              filterPlannedIncomes(widget.updatePlannedIncomes);
            },
          )
        ],
      ),
    );
  }
}
