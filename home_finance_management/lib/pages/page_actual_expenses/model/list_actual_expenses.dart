class ActualExpenses {
  int idActualExpenses;
  DateTime dateActualExpenses;
  double sumActualExpenses;
  String categoryActualExpenses;

  ActualExpenses(
      {required this.idActualExpenses,
      required this.dateActualExpenses,
      required this.sumActualExpenses,
      required this.categoryActualExpenses});
}

List<ActualExpenses> listActualExpenses = [];
