import 'package:flutter/material.dart';
import '../../controller/drawer_menu.dart';
import '../../controller/icon_button_menu.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key});

  @override
  State<ViewHistory> createState() => _ViewHistory();
}

class _ViewHistory extends State<ViewHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "История",
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
          plannedExpensesPage: true,
          statisticsPage: true,
          historyPage: false),
    );
  }

  void update() {
    setState(() {});
  }
}
