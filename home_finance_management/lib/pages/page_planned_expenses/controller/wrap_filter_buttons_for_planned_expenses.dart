import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_expenses/components/filter_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/filter_dates_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/filtered_planned_expenses_list.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/list_planned_expenses.dart';

class WrapFilterButtonsForPlannedExpenses extends StatefulWidget {
  final VoidCallback updatePlannedExpenses;

  const WrapFilterButtonsForPlannedExpenses(
      {super.key, required this.updatePlannedExpenses});

  @override
  State<WrapFilterButtonsForPlannedExpenses> createState() =>
      _WrapFilterButtonsForPlannedExpensesState();
}

class _WrapFilterButtonsForPlannedExpensesState
    extends State<WrapFilterButtonsForPlannedExpenses> {
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
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2124),
                  );
                  if (picked != null) {
                    setState(() {
                      filterDatesPlannedExpenses[0].startDatePlannedExpenses =
                          picked;
                      filterPlannedExpenses(widget.updatePlannedExpenses);
                    });
                  }
                },
                child: const Text('Выбрать начальную дату',
                    textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2124),
                  );
                  if (picked != null) {
                    setState(() {
                      filterDatesPlannedExpenses[0].endDatePlannedExpenses =
                          picked;
                      filterPlannedExpenses(widget.updatePlannedExpenses);
                    });
                  }
                },
                child: const Text('Выбрать конечную дату',
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              filteredPlannedExpensesList = listPlannedExpenses;
              filterDatesPlannedExpenses = [
                FilterForPlannedExpenses(
                    startDatePlannedExpenses:
                        DateTime.now().subtract(const Duration(days: 1)),
                    endDatePlannedExpenses: DateTime(2124))
              ];
              filterPlannedExpenses(widget.updatePlannedExpenses);
            });
          },
          child: const Text('Сбросить фильтр', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
