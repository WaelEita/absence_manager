import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class RemoveDialog<T> extends StatelessWidget {
  final T person;
  final String title;
  final String content;
  final Function(T) onRemove;

  const RemoveDialog({
    super.key,
    required this.person,
    required this.title,
    required this.content,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(
        title,
        textAlign: TextAlign.right,
      ),
      content: Text(
        content,
        textAlign: TextAlign.right,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child:
              Text('إلغاء', style: regularText18.copyWith(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            onRemove(person);
            Navigator.of(context).pop();
          },
          child: Text(
            'تأكيد',
            style: regularText18.copyWith(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
