import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/home_page_background.dart';
import 'package:flutter_app_project1/ui/slidable_bottom_sheet.dart';
import 'package:flutter_app_project1/ui/sliding_cards_page.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class StatPage extends StatefulWidget {
  final Function onMenuTap;

  const StatPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> with TickerProviderStateMixin {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final User user = _auth.currentUser;

    return Consumer(
      builder: (context, watch, child) {
        var isMenu = watch(menuProvider);

        return Scaffold(
          //appBar: appBar,
          body: Stack(children: <Widget>[
            HomePageBackground(
              screenHeight: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: GestureDetector(
                          onTap: widget.onMenuTap,
                          child: Container(
                              child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          )),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: WavyAnimatedTextKit(
                        repeatForever: true,
                        textStyle: TextStyle(
                            fontSize: 20.0,
                          color: Colors.white
                        ),
                        text: [
                          "Drizzle님 안녕하세요.",
                          "오늘도 영감을 얻으세요.",
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ),
                  SlidingCardsPage(),
                ],
              ),
            ),
            ScrollableExhibitionSheet(),
          ]),
        );
      },
    );
  }
}
