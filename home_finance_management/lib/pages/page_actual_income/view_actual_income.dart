import 'package:flutter/material.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/dropdown_button_currency_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/wrap_filter_buttons_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/elevated_button_save_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/elevated_button_select_date_actual_incomes.dart';
import 'package:home_finance_management/controller/drawer_menu.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/list_tile_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/controller/text_field_enter_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/text_controller_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

class ViewActualIncome extends StatefulWidget {
  const ViewActualIncome({super.key});

  @override
  State<ViewActualIncome> createState() => _ViewActualIncomeState();
}

class _ViewActualIncomeState extends State<ViewActualIncome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingActualIncomes = true;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeSymptoms();
  }

  Future<void> initializeSymptoms() async {
    listActualIncomes = await getActualIncomesFromDatabase();
    listActualIncomes
        .sort((a, b) => a.dateActualIncomes.compareTo(b.dateActualIncomes));
    filterActualIncomes(updateState);
    setState(() {
      isLoadingActualIncomes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Фактические доходы",
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
          actualIncomePage: false,
          actualExpensesPage: true,
          plannedIncomePage: true,
          plannedExpensesPage: true,
          statisticsPage: true),
      body: isLoadingActualIncomes
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldEnterForActualIncomes(
                            labelText: 'Введите доход',
                            textControllerActualIncomes:
                                textControllerActualIncomes,
                            keyboardType: TextInputType.number),
                      ),
                      const DropdownButtonCurrencyForActualIncomes(),
                    ],
                  ),
                  Row(children: [
                    const Expanded(
                      child: ElevatedButtonSelectDateActualIncomes(),
                    ),
                    Expanded(
                      child: ElevatedButtonSaveActualIncomes(
                          updateActualIncomes: updateState),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredActualIncomesList.length,
                      itemBuilder: (context, index) {
                        return ListTileActualIncomes(
                          updateActualIncomes: updateState,
                          index: index,
                        );
                      },
                    ),
                  ),
                  if (listActualIncomes.isNotEmpty)
                    WrapFilterButtonsForActualIncomes(
                        updateActualIncomes: updateState),
                ],
              ),
            ),
    );
  }
}
