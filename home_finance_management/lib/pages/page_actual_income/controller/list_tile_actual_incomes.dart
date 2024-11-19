import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/component/text_button_cancel.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:intl/intl.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
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
  State<ListTileActualIncomes> createState() => _ListTileActualIncomesState();
}

class _ListTileActualIncomesState extends State<ListTileActualIncomes> {
  DateTime? selectedDate;
  TextEditingController? sumControllerActualIncomes;

  @override
  void initState() {
    super.initState();
    sumControllerActualIncomes = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${filteredActualIncomesList[widget.index].sumActualIncomes} рублей',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        DateFormat('d.M.y')
            .format(filteredActualIncomesList[widget.index].dateActualIncomes),
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
              sumControllerActualIncomes?.text =
                  filteredActualIncomesList[widget.index]
                      .sumActualIncomes
                      .toString();
              selectedDate =
                  filteredActualIncomesList[widget.index].dateActualIncomes;
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
                              child: TextFieldEnterForActualIncomes(
                                textControllerActualIncomes:
                                    sumControllerActualIncomes,
                              ),
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
                                  filteredActualIncomesList[widget.index]
                                      .dateActualIncomes,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
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
                                double.parse(sumControllerActualIncomes!.text);
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
                          if (sumControllerActualIncomes!.text.isNotEmpty &&
                              selectedDate != null) {
                            {
                              final actualIncomeIndex =
                                  listActualIncomes.indexWhere((actualIncome) =>
                                      actualIncome.idActualIncomes ==
                                      filteredActualIncomesList[widget.index]
                                          .idActualIncomes);
                              if (actualIncomeIndex != -1) {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.updateActualIncome({
                                  'id': filteredActualIncomesList[widget.index]
                                      .idActualIncomes,
                                  'date': selectedDate!.toIso8601String(),
                                  'sum': double.parse(
                                      convertedSum.toStringAsFixed(2)),
                                });
                                listActualIncomes =
                                    await getActualIncomesFromDatabase();
                                listActualIncomes.sort((a, b) => a
                                    .dateActualIncomes
                                    .compareTo(b.dateActualIncomes));
                                filterActualIncomes(widget.updateActualIncomes);
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
              await dbHelper.deleteActualIncome(
                  filteredActualIncomesList[widget.index].idActualIncomes);
              listActualIncomes = await getActualIncomesFromDatabase();
              filterActualIncomes(widget.updateActualIncomes);
            },
          )
        ],
      ),
    );
  }
}
