import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/components/text_button_cancel_alert_dialog_for_planned_incomes.dart';

void showErrorDialogForPlannedIncomes(
    BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: const [
          TextButtonCancelAlertDialogForPlannedIncomes(text: 'ОК'),
        ],
      );
    },
  );
}
