import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/elevated_button_save_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/elevated_button_select_date_planned_incomes.dart';
import 'package:home_finance_management/controller/drawer_menu.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/list_tile_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/text_field_enter_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/controller/wrap_filter_buttons_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/text_controller_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_planned_incomes_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';

class ViewPlannedIncome extends StatefulWidget {
  const ViewPlannedIncome({super.key});

  @override
  State<ViewPlannedIncome> createState() => _ViewPlannedIncomeState();
}

class _ViewPlannedIncomeState extends State<ViewPlannedIncome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlannedIncomes();
  }

  Future<void> initializePlannedIncomes() async {
    listPlannedIncomes = await getPlannedIncomesFromDatabase();
    listPlannedIncomes
        .sort((a, b) => a.datePlannedIncomes.compareTo(b.datePlannedIncomes));
    filterPlannedIncomes(updateState);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Запланированные доходы",
          style: TextStyle(
            color: Colors.green,
            fontSize: 22,
          ),
        ),
        leading: const Icon(
          Icons.schedule,
          color: Colors.green,
        ),
        centerTitle: true,
        actions: [
          IconButtonMenu(scaffoldKey: _scaffoldKey),
        ],
      ),
      endDrawer: const DrawerMenu(
          actualIncomePage: true,
          actualExpensesPage: true,
          plannedIncomePage: false,
          plannedExpensesPage: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldEnterForPlannedIncomes(
                          textControllerPlannedIncomes:
                              textControllerPlannedIncomes,
                        ),
                      ),
                      const DropdownButtonCurrency(),
                    ],
                  ),
                  Row(children: [
                    const Expanded(
                      child: ElevatedButtonSelectDatePlannedIncomes(),
                    ),
                    Expanded(
                      child: ElevatedButtonSavePlannedIncomes(
                          updatePlannedIncomes: updateState),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPlannedIncomesList.length,
                      itemBuilder: (context, index) {
                        return ListTilePlannedIncomes(
                          updatePlannedIncomes: updateState,
                          index: index,
                        );
                      },
                    ),
                  ),
                  if (listPlannedIncomes.isNotEmpty)
                    WrapFilterButtonsForPlannedIncomes(
                        updatePlannedIncomes: updateState),
                ],
              ),
            ),
    );
  }
}
