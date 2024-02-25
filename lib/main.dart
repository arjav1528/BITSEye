// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'screens/list.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardList(),
    ),
  ));
}
