import 'package:flutter/material.dart';
import 'package:newproject2/custom_theme.dart';

class Buildtag extends StatelessWidget {
  const Buildtag({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomTheme.darkScaffoldColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFBDBDBD),
          width: 0.1,
        ),
      ),
      child: Text(
        text!,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
