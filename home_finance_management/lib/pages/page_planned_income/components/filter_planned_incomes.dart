import 'package:home_finance_management/pages/page_planned_income/model/filter_dates_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_planned_incomes_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';

void filterPlannedIncomes(Function updateState) {
  filteredPlannedIncomesList = listPlannedIncomes.where((plannedIncome) {
    return (plannedIncome.datePlannedIncomes.isAfter(
                filterDatesPlannedIncomes[0].startDatePlannedIncomes) ||
            plannedIncome.datePlannedIncomes.isAtSameMomentAs(
                filterDatesPlannedIncomes[0].startDatePlannedIncomes)) &&
        (plannedIncome.datePlannedIncomes
                .isBefore(filterDatesPlannedIncomes[0].endDatePlannedIncomes) ||
            plannedIncome.datePlannedIncomes.isAtSameMomentAs(
                filterDatesPlannedIncomes[0].endDatePlannedIncomes));
  }).toList();

  updateState();
}
