class FilterForPlannedIncomes {
  DateTime startDatePlannedIncomes;
  DateTime endDatePlannedIncomes;

  FilterForPlannedIncomes({required this.startDatePlannedIncomes, required this.endDatePlannedIncomes});
}

List<FilterForPlannedIncomes> filterDatesPlannedIncomes = [
  FilterForPlannedIncomes(startDatePlannedIncomes: DateTime(2000, 1, 1), endDatePlannedIncomes: DateTime.now())
];
