class PlannedExpenses {
  int idPlannedExpenses;
  DateTime datePlannedExpenses;
  double sumPlannedExpenses;
  String categoryPlannedExpenses;

  PlannedExpenses(
      {required this.idPlannedExpenses,
      required this.datePlannedExpenses,
      required this.sumPlannedExpenses,
      required this.categoryPlannedExpenses});
}

List<PlannedExpenses> listPlannedExpenses = [];
