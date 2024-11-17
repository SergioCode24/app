import 'package:home_finance_management/pages/page_planned_expenses/model/filter_dates_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/filtered_planned_expenses_list.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/list_planned_expenses.dart';

void filterPlannedExpenses(Function updateState) {
  filteredPlannedExpensesList = listPlannedExpenses.where((plannedExpenses) {
    return (plannedExpenses.datePlannedExpenses.isAfter(
                filterDatesPlannedExpenses[0].startDatePlannedExpenses) ||
            plannedExpenses.datePlannedExpenses.isAtSameMomentAs(
                filterDatesPlannedExpenses[0].startDatePlannedExpenses)) &&
        (plannedExpenses.datePlannedExpenses.isBefore(
                filterDatesPlannedExpenses[0].endDatePlannedExpenses) ||
            plannedExpenses.datePlannedExpenses.isAtSameMomentAs(
                filterDatesPlannedExpenses[0].endDatePlannedExpenses));
  }).toList();
  updateState();
}
