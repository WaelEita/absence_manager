import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class AddDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final List<String> existingNames;
  final Function(String) onAdded;

  const AddDialog({
    super.key,
    required this.title,
    required this.hintText,
    required this.existingNames,
    required this.onAdded,
  });

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(
        widget.title,
        textAlign: TextAlign.end,
      ),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'إلغاء',
            style: regularText18.copyWith(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            _handleConfirm();
          },
          child:
          Text('تأكيد', style: regularText18.copyWith(color: primaryColor)),
        ),
      ],
    );
  }

  void _handleConfirm() {
    final newName = _textController.text.trim();
    if (newName.isNotEmpty) {
      if (!widget.existingNames.contains(newName)) {
        widget.onAdded(newName);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('موجود بالفعل في القائمة!'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
