class FilterForPlannedIncomes {
  DateTime startDatePlannedIncomes;
  DateTime endDatePlannedIncomes;

  FilterForPlannedIncomes(
      {required this.startDatePlannedIncomes,
      required this.endDatePlannedIncomes});
}

List<FilterForPlannedIncomes> filterDatesPlannedIncomes = [
  FilterForPlannedIncomes(
      startDatePlannedIncomes: DateTime.now().subtract(const Duration(days: 1)),
      endDatePlannedIncomes: DateTime(2124))
];
