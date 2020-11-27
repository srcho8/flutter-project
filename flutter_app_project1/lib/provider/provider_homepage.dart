import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/ui/calendar_page.dart';
import 'package:flutter_app_project1/ui/insfire_page.dart';
import 'package:flutter_app_project1/ui/memo_page.dart';
import 'package:flutter_app_project1/ui/mine_page.dart';
import 'package:flutter_app_project1/ui/stat_page.dart';
import 'package:flutter_app_project1/ui/test.dart';
import 'package:flutter_app_project1/ui/test2.dart';

class FirstPageIndex with ChangeNotifier {
  int _f_index = 0;

  int get f_index => _f_index;

  set f_index(int f_index) => _f_index = f_index;

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> widgetOptions = <Widget>[
    Test2(),
    InsFirePage(),
    CalendarPage()
    //MinePage(),
  ];

}

