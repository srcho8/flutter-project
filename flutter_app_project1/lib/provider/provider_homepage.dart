import 'package:flutter/material.dart';
import 'package:flutter_app_project1/ui/calendar_page.dart';
import 'package:flutter_app_project1/ui/insfire_page.dart';
import 'package:flutter_app_project1/ui/stat_page.dart';

enum NavigationEvents {
  DashboardClickedEvent,
  MessagesClickedEvent,
  UtilityClickedEvent
}

abstract class NavigationStates {}


class FirstPageIndex extends ChangeNotifier  {
  final Function onMenuTap;

  FirstPageIndex({this.onMenuTap});

  @override
  NavigationStates get initialState => StatPage(
    onMenuTap: onMenuTap,
  );

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.DashboardClickedEvent:
        yield StatPage(
          onMenuTap: onMenuTap,
        );
        break;
      // case NavigationEvents.MessagesClickedEvent:
      //   yield InsFirePage(
      //     onMenuTap: onMenuTap,
      //   );
      //   break;
      case NavigationEvents.UtilityClickedEvent:
        yield CalendarPage(
          onMenuTap: onMenuTap,
        );
        break;
    }
  }


  int _f_index = 0;

  int get f_index => _f_index;

  set f_index(int f_index) => _f_index = f_index;

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> widgetOptions = <Widget>[
    StatPage(),
    InsFirePage(),
    CalendarPage(),
  ];
}
