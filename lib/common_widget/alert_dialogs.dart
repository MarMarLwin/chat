import 'package:flutter/material.dart';
import 'package:chat_supabase/utils/extensions.dart';

class ConfirmDialog {
  static show({
    required BuildContext context,
    required String title,
    required String content,
    Function? onPressedOk,
    Function? onPressedCancel,
    String leftTitleButton = 'OK',
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
        content: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child:
                Text(content, style: Theme.of(context).textTheme.bodyMedium)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (onPressedCancel == null) return;
                    onPressedCancel();
                  },
                  child: Text('Cancel'.toUpper(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900))),
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (onPressedOk == null) return;
                    onPressedOk();
                  },
                  child: Text(leftTitleButton.toUpper(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900))),
            ],
          ),
        ],
      ),
    );
  }
}
