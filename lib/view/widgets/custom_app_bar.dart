import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 26),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: title20.copyWith(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: primaryColor,
    );
  }
}
