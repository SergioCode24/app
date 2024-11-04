import '../model/filter_dates.dart';
import '../model/filtered_list.dart';
import '../model/list_incomes.dart';

void filterPlannedIncomes(Function updateState) {
  filteredPlannedIncomesList = listPlannedIncomes.where((plannedIncome) {
    return (plannedIncome.date.isAfter(filterDatesPlannedIncomes[0].startDatePlannedIncomes) ||
        plannedIncome.date.isAtSameMomentAs(filterDatesPlannedIncomes[0].startDatePlannedIncomes)) &&
        (plannedIncome.date.isBefore(filterDatesPlannedIncomes[0].endDatePlannedIncomes) ||
            plannedIncome.date.isAtSameMomentAs(filterDatesPlannedIncomes[0].endDatePlannedIncomes));
  }).toList();

  updateState(); // Обновление состояния
}