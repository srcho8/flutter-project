import 'package:flutter/material.dart';

class FirstPageIndex with ChangeNotifier {
  int _f_index = 0;

  int get f_index => _f_index;

  set f_index(int f_index) => _f_index = f_index;

  static TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];


}