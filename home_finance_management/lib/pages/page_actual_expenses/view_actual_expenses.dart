import 'package:flutter/material.dart';
import 'package:home_finance_management/controller/icon_button_menu.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/dropdown_button_currency_for_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/wrap_filter_buttons_for_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/elevated_button_save_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/elevated_button_select_date_actual_expenses.dart';
import 'package:home_finance_management/controller/drawer_menu.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/list_tile_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/text_field_enter_for_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/text_controller_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filtered_actual_expenses_list.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/controller/dropdown_button_category_for_actual_expenses.dart';

class ViewActualExpenses extends StatefulWidget {
  const ViewActualExpenses({super.key});

  @override
  State<ViewActualExpenses> createState() => _ViewActualExpensesState();
}

class _ViewActualExpensesState extends State<ViewActualExpenses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingActualExpenses = true;
  final TextEditingController textControllerCategoriesActualExpenses = TextEditingController();

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeActualExpenses();
  }

  Future<void> initializeActualExpenses() async {
    listActualExpenses = await getActualExpensesFromDatabase();
    listActualExpenses
        .sort((a, b) => a.dateActualExpenses.compareTo(b.dateActualExpenses));
    filterActualExpenses(updateState);
    setState(() {
      isLoadingActualExpenses = false;
    });
  }

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
          statisticsPage: true),
      body: isLoadingActualExpenses
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldEnterForActualExpenses(
                            labelText: 'Введите расход',
                            textControllerActualExpenses:
                                textControllerActualExpenses,
                            keyboardType: TextInputType.number),
                      ),
                      const DropdownButtonCurrencyForActualExpenses(),
                    ],
                  ),
                  Expanded(child:
                  Row(
                    children: [
                      Expanded(child:
                      const DropdownButtonCategoryForActualExpenses(),),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Добавить новую категорию'),
                                content: TextField(
                                  controller: textControllerCategoriesActualExpenses,
                                  decoration: const InputDecoration(
                                    hintText: 'Введите название категории',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (textControllerCategoriesActualExpenses.text.isNotEmpty) {
                                        setState(() {
                                          categoriesActualExpenses.add(CategoryActualExpenses(
                                              nameActualExpenses: textControllerCategoriesActualExpenses.text));
                                          selectedCategoryActualExpenses = textControllerCategoriesActualExpenses.text;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Добавить'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),),
                  Row(children: [
                    const Expanded(
                      child: ElevatedButtonSelectDateActualExpenses(),
                    ),
                    Expanded(
                      child: ElevatedButtonSaveActualExpenses(
                          updateActualExpenses: updateState),
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredActualExpensesList.length,
                      itemBuilder: (context, index) {
                        return ListTileActualExpenses(
                          updateActualExpenses: updateState,
                          index: index,
                        );
                      },
                    ),
                  ),
                  if (listActualExpenses.isNotEmpty)
                    WrapFilterButtonsForActualExpenses(
                        updateActualExpenses: updateState),
                ],
              ),
            ),
    );
  }
}
