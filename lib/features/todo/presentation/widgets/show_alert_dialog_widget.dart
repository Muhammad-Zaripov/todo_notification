import 'package:flutter/material.dart';
import 'package:todo_app/features/auth/presentation/widgets/text_form_field_widget.dart';

class ShowAlertDialogWidget extends StatelessWidget {
  const ShowAlertDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    return AlertDialog(
      backgroundColor: Color(0xFF8687E7),
      title: Text('Add Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [WTextField(controller: titleController)],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: TextStyle(fontSize: 18)),
            ),
            InkWell(
              onTap: () {},
              child: Text('Add', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }
}
