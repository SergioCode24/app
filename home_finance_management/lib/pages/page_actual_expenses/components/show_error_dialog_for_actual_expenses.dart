import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/text_button_cancel_alert_dialog_for_actual_expenses.dart';

void showErrorDialogForActualExpenses(
    BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: const [
          TextButtonCancelAlertDialogForActualExpenses(text: 'ОК'),
        ],
      );
    },
  );
}
