import 'package:flutter/material.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/dropdown_button_currency_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/wrap_filter_buttons_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/elevated_button_save_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/elevated_button_select_date_actual_incomes.dart';
import 'package:home_finance_management/controller/drawer_menu.dart';
import 'components/database_helper_for_planned_incomes.dart';
import 'components/filter_planned_incomes.dart';
import 'controller/list_tile_incomes.dart';
import 'controller/text_field_enter.dart';
import 'model/text_controller.dart';
import 'model/filtered_list.dart';
import 'model/list_incomes.dart';

class ViewPlannedIncome extends StatefulWidget {
  const ViewPlannedIncome({super.key});

  @override
  State<ViewPlannedIncome> createState() => _ViewPlannedIncome();
}

class _ViewPlannedIncome extends State<ViewPlannedIncome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  String selectedCurrency = 'RUB';

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeSymptoms();
  }

  Future<void> _initializeSymptoms() async {
    listPlannedIncomes = await getPlannedIncomesFromDatabase();
    listPlannedIncomes.sort((a, b) => a.date.compareTo(b.date));
    filterPlannedIncomes(updateState); // Обновление фильтрованного списка
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Запланированные доходы",
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
          plannedIncomePage: false,
          plannedExpensesPage: true,
          statisticsPage: true,
          historyPage: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldEnter(
                            labelText: 'Введите доход',
                            controller: textController,
                            keyboardType: TextInputType.number),
                      ),
                      DropdownButtonCurrencyForActualIncomes(
                          selectedCurrencyActualIncomes: selectedCurrency),
                    ],
                  ),
                  Row(children: [
                    const Expanded(
                      child: ElevatedButtonSelectDateActualIncomes(),
                    ),
                    Expanded(
                      child: ElevatedButtonSaveActualIncomes(
                          updateActualIncomes: updateState,
                          selectedCurrencyActualIncomes: selectedCurrency),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPlannedIncomesList.length,
                      itemBuilder: (context, index) {
                        return ListTileIncomes(
                          onSave: updateState,
                          index: index,
                        );
                      },
                    ),
                  ),
                  if (listPlannedIncomes.isNotEmpty)
                    WrapFilterButtonsForActualIncomes(updateActualIncomes: updateState),
                ],
              ),
            ),
    );
  }
}
