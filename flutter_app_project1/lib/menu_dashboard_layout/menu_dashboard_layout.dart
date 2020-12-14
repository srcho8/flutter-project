import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:InsFire/menu_dashboard_layout/dashboard.dart';
import 'package:InsFire/provider/state_manager.dart';
import 'package:InsFire/ui/calendar_page.dart';
import 'package:InsFire/ui/insfire_page.dart';
import 'package:InsFire/ui/myroom_page.dart';
import 'package:InsFire/ui/sticky_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'menu.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class MenuDashboardLayout extends StatefulWidget {
  @override
  _MenuDashboardLayoutState createState() => _MenuDashboardLayoutState();
}

class _MenuDashboardLayoutState extends State<MenuDashboardLayout>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
  bool isCollapsed = true;
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    secureScreen();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onMenuItemClicked() {
    _controller.reverse();

    isCollapsed = !isCollapsed;
  }

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    final pageState = StateProvider<Widget>((ref) {
      Widget _selectedWidget;
      int _pages = ref.watch(pageProvider).state;

      switch (_pages) {
        case 0:
          return StatPage(onMenuTap: this.onMenuTap);
          break;
        case 1:
          return InsFirePage(onMenuTap: this.onMenuTap);
          break;
        case 2:
          return CalendarPage(onMenuTap: this.onMenuTap);
          break;
        case 3:
          return StickyListPage(onMenuTap: this.onMenuTap);
          break;
      }

      return _selectedWidget;
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer(
        builder: (context, watch, child) {
          Widget pages = watch(pageState).state;
          int _selectedPage = watch(pageProvider).state;

          return Stack(
            children: <Widget>[
              Menu(
                slideAnimation: _slideAnimation,
                menuAnimation: _menuScaleAnimation,
                selectedIndex: _selectedPage,
                onMenuItemClicked: onMenuItemClicked,
              ),
              Dashboard(
                  duration: duration,
                  onMenuTap: onMenuTap,
                  scaleAnimation: _scaleAnimation,
                  isCollapsed: isCollapsed,
                  screenWidth: screenWidth,
                  child: pages),
            ],
          );
        },
      ),
    );
  }
}
