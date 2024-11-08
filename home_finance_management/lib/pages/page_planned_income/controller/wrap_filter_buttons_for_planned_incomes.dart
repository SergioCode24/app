import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filter_dates_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_planned_incomes_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';

class WrapFilterButtonsForPlannedIncomes extends StatefulWidget {
  final VoidCallback updatePlannedIncomes;

  const WrapFilterButtonsForPlannedIncomes(
      {super.key, required this.updatePlannedIncomes});

  @override
  State<WrapFilterButtonsForPlannedIncomes> createState() =>
      _WrapFilterButtonsForPlannedIncomesState();
}

class _WrapFilterButtonsForPlannedIncomesState
    extends State<WrapFilterButtonsForPlannedIncomes> {
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
                      filterDatesPlannedIncomes[0].startDatePlannedIncomes =
                          picked;
                      filterPlannedIncomes(widget.updatePlannedIncomes);
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
                      filterDatesPlannedIncomes[0].endDatePlannedIncomes =
                          picked;
                      filterPlannedIncomes(widget.updatePlannedIncomes);
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
              filteredPlannedIncomesList = listPlannedIncomes;
              filterDatesPlannedIncomes = [
                FilterForPlannedIncomes(
                    startDatePlannedIncomes: DateTime.now().subtract(const Duration(days: 1)),
                    endDatePlannedIncomes: DateTime(2124))
              ];
              filterPlannedIncomes(widget.updatePlannedIncomes);
            });
          },
          child: const Text('Сбросить фильтр', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
