import 'package:flutter/material.dart';
import '../../controller/drawer_menu.dart';
import '../../controller/icon_button_menu.dart';

class ViewPlannedExpenses extends StatefulWidget {
  const ViewPlannedExpenses({super.key});

  @override
  State<ViewPlannedExpenses> createState() => _ViewPlannedExpenses();
}

class _ViewPlannedExpenses extends State<ViewPlannedExpenses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Запланированные расходы",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.grey,
        centerTitle: true,
        actions: [
          IconButtonMenu(scaffoldKey: _scaffoldKey),
        ],
      ),
      endDrawer: const DrawerMenu(
          actualIncomePage: true,
          actualExpensesPage: true,
          plannedIncomePage: true,
          plannedExpensesPage: false,
          statisticsPage: true,
          historyPage: true),
    );
  }

  void update() {
    setState(() {});
  }
}
