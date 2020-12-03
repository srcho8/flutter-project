import 'package:flutter/material.dart';
import 'package:flutter_app_project1/menu_dashboard_layout/dashboard.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class MenuDashboardLayout extends StatefulWidget {
  @override
  _MenuDashboardLayoutState createState() => _MenuDashboardLayoutState();
}

class _MenuDashboardLayoutState extends State<MenuDashboardLayout>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

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
                  onMenuItemClicked: onMenuItemClicked),
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

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  void onMenuItemClicked() {
    _controller.reverse();

    isCollapsed = !isCollapsed;
  }
}
