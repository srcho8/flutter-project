import 'package:flutter/material.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_riverpod/all.dart';

class Menu extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> menuAnimation;
  final int selectedIndex;
  final Function onMenuItemClicked;

  const Menu({Key key, this.slideAnimation, this.menuAnimation, this.selectedIndex, @required this.onMenuItemClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Consumer(
              builder: (context, watch, child){
                int _selectPage = watch(pageProvider).state;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _selectPage = 0;
                        onMenuItemClicked();
                      },
                      child: Text(
                        "Stats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: selectedIndex == 0 ? FontWeight.w900 : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _selectPage = 1;
                        onMenuItemClicked();
                      },
                      child: Text(
                        "InsFire",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: selectedIndex == 1 ? FontWeight.w900 : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _selectPage = 2;
                        onMenuItemClicked();
                      },
                      child: Text(
                        "Calendar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: selectedIndex == 2 ? FontWeight.w900 : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Funds Transfer", style: TextStyle(color: Colors.white, fontSize: 22)),
                    SizedBox(height: 30),
                    Text("Branches", style: TextStyle(color: Colors.white, fontSize: 22)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
