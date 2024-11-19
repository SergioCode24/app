import 'package:flutter/material.dart';
import 'package:home_finance_management/controller/dropdown_button_currency.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import 'package:home_finance_management/controller/icon_button_add_new_category.dart';
import 'package:home_finance_management/controller/icon_button_reset_categories.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/wrap_filter_buttons_for_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/elevated_button_save_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/elevated_button_select_date_planned_expenses.dart';
import 'package:home_finance_management/controller/drawer_menu.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_planned_expenses/components/filter_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/list_tile_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/controller/text_field_enter_for_planned_expenses.dart';
import 'package:home_finance_management/model/categories.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/text_controller_planned_expenses.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/filtered_planned_expenses_list.dart';
import 'package:home_finance_management/pages/page_planned_expenses/model/list_planned_expenses.dart';
import 'package:home_finance_management/controller/dropdown_button_category.dart';

class ViewPlannedExpenses extends StatefulWidget {
  const ViewPlannedExpenses({super.key});

  @override
  State<ViewPlannedExpenses> createState() => _ViewPlannedExpensesState();
}

class _ViewPlannedExpensesState extends State<ViewPlannedExpenses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingPlannedExpenses = true;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeActualExpenses();
  }

  Future<void> initializeActualExpenses() async {
    listPlannedExpenses = await getPlannedExpensesFromDatabase();
    listPlannedExpenses
        .sort((a, b) => a.datePlannedExpenses.compareTo(b.datePlannedExpenses));
    categories = await getCategoriesFromDatabase();
    if (categories.isEmpty) {
      DatabaseHelper().insertDefaultCategories();
    }
    filterPlannedExpenses(updateState);
    setState(() {
      isLoadingPlannedExpenses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Запланированные расходы",
          style: TextStyle(
            color: Colors.red,
            fontSize: 21,
          ),
        ),
        leading: const Icon(
          Icons.schedule,
          color: Colors.red,
        ),
        centerTitle: true,
        actions: [
          IconButtonMenu(scaffoldKey: _scaffoldKey),
        ],
      ),
      endDrawer: const DrawerMenu(
          actualIncomePage: true,
          actualExpensesPage: true,
          plannedIncomePage: true,
          plannedExpensesPage: false),
      body: isLoadingPlannedExpenses
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldEnterForPlannedExpenses(
                            labelText: 'Введите расход',
                            textControllerPlannedExpenses:
                                textControllerPlannedExpenses,
                            keyboardType: TextInputType.number),
                      ),
                      const DropdownButtonCurrency(),
                    ],
                  ),
                  Row(
                    children: [
                      DropdownButtonCategory(updateState: updateState),
                      IconButtonAddNewCategory(updateState: updateState),
                      IconButtonResetCategories(updateState: updateState),
                    ],
                  ),
                  Row(children: [
                    const Expanded(
                      child: ElevatedButtonSelectDatePlannedExpenses(),
                    ),
                    Expanded(
                      child: ElevatedButtonSavePlannedExpenses(
                          updatePlannedExpenses: updateState),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPlannedExpensesList.length,
                      itemBuilder: (context, index) {
                        return ListTilePlannedExpenses(
                          updatePlannedExpenses: updateState,
                          index: index,
                        );
                      },
                    ),
                  ),
                  if (listPlannedExpenses.isNotEmpty)
                    WrapFilterButtonsForPlannedExpenses(
                        updatePlannedExpenses: updateState),
                ],
              ),
            ),
    );
  }
}
