// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:newproject2/custom_theme.dart';
import 'screens/list.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: CustomTheme.darkTextTheme,
    ),
    debugShowCheckedModeBanner: false,
    home: CardList(),
  ));
}
