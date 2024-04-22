import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.appBarWidget})
      : preferredSize = const Size.fromHeight(50.0);
  final Widget appBarWidget;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: appBarWidget,
    );
  }
}