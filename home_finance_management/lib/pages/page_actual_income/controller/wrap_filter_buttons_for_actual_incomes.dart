import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filter_dates_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

class WrapFilterButtonsForActualIncomes extends StatefulWidget {
  final VoidCallback updateActualIncomes;

  const WrapFilterButtonsForActualIncomes(
      {super.key, required this.updateActualIncomes});

  @override
  State<WrapFilterButtonsForActualIncomes> createState() =>
      _WrapFilterButtonsForActualIncomesState();
}

class _WrapFilterButtonsForActualIncomesState
    extends State<WrapFilterButtonsForActualIncomes> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
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
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
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
                    setState(() {
                      filterDatesActualIncomes[0].startDateActualIncomes =
                          picked;
                      filterActualIncomes(widget.updateActualIncomes);
                    });
                  }
                },
                child: const Text(
                  'Выбрать начальную дату',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
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
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
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
                    setState(() {
                      filterDatesActualIncomes[0].endDateActualIncomes = picked;
                      filterActualIncomes(widget.updateActualIncomes);
                    });
                  }
                },
                child: const Text(
                  'Выбрать конечную дату',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white24),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.white),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              filteredActualIncomesList = listActualIncomes;
              filterDatesActualIncomes = [
                FilterForActualIncomes(
                    startDateActualIncomes: DateTime(2000),
                    endDateActualIncomes: DateTime.now())
              ];
              filterActualIncomes(widget.updateActualIncomes);
            });
          },
          child: const Text(
            'Сбросить фильтр',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
