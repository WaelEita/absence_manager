import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class PersonCard<T> extends StatelessWidget {
  final T person;
  final String title;
  final Function(T) onRemove;
  final Function(T)? onTap;
  final Function()? onLongPress;
  final bool isSelected;

  const PersonCard({
    super.key,
    required this.person,
    required this.title,
    required this.onRemove,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: isSelected
            ? Icon(
          Icons.check_circle,
          color: primaryColor,
        )
            : null,
        trailing: const Icon(Icons.person, color: primaryColor),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          child: Text(
            title,
            style: regularText18,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
        ),
        tileColor: secondaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap != null ? () => onTap!(person) : null,
        onLongPress: onLongPress,
      ),
    );
  }
}
