import 'package:flutter/material.dart';

mixin SnackBarMixin {
  void showSnackBarTop(
    BuildContext context, {
    required String text,
    Color? color = Colors.green,
  }) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: color,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Container(),
        ],
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      },
    );
  }
}
