import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/home_page_background.dart';
import 'package:flutter_app_project1/ui/scrollable_exhibition_sheet.dart';
import 'package:flutter_app_project1/ui/sliding_cards_page.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    height: 110,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                        child: Text(
                      'Drizzle님 안녕하세요.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.yeonSung(
                          fontSize: 24, color: Colors.white),
                    )),
                  ),
                  SlidingCardsPage(),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      border: Border(top:BorderSide(color: Colors.blueGrey))
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Center(
                        child: Text(
                          'My Posts',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.yeonSung(
                              fontSize: 16, color: Colors.blueGrey),
                        )),
                  ),
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
