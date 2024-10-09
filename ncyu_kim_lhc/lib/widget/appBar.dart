import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final bool showActionButton; // 是否顯示動作按鈕
  final bool showLeadingButton;
  final VoidCallback? actionButtonCallback; // 動作按鈕的回調
  final IconData actionButtonIcon; // 動作按鈕的圖標
  final double textSize;

  const SharedAppBar({
    super.key,
    required this.titleText,
    this.showActionButton = false, // 默認不顯示
    this.actionButtonCallback,
    this.actionButtonIcon = Icons.add, // 默認圖標
    this.textSize = 25,
    this.showLeadingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showLeadingButton,
      title: Text(
        titleText,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      actions: showActionButton ? [
        IconButton(
          icon: Icon(actionButtonIcon),
          onPressed: actionButtonCallback,
        ),
      ] : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}