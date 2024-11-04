import 'package:flutter/material.dart';
import '../../controller/drawer_menu.dart';
import '../../controller/icon_button_menu.dart';

class ViewActualExpenses extends StatefulWidget {
  const ViewActualExpenses({super.key});

  @override
  State<ViewActualExpenses> createState() => _ViewActualExpenses();
}

class _ViewActualExpenses extends State<ViewActualExpenses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Фактические расходы",
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
          actualExpensesPage: false,
          plannedIncomePage: true,
          plannedExpensesPage: true,
          statisticsPage: true,
          historyPage: true),
    );
  }

  void update() {
    setState(() {});
  }
}
