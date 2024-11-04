import 'package:flutter/material.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import '../../controller/drawer_menu.dart';

class ViewStatistics extends StatefulWidget {
  const ViewStatistics({super.key});

  @override
  State<ViewStatistics> createState() => _ViewStatistics();
}

class _ViewStatistics extends State<ViewStatistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Статистика",
          style: TextStyle(
            fontSize: 26,
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
          plannedExpensesPage: true,
          statisticsPage: false,
          historyPage: true),
    );
  }

  void update() {
    setState(() {});
  }
}