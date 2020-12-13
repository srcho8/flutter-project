import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:InsFire/provider/state_manager.dart';
import 'package:InsFire/ui/home_page_background.dart';
import 'package:InsFire/ui/scrollable_exhibition_sheet.dart';
import 'package:InsFire/ui/sliding_cards_page.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';

class StatPage extends StatefulWidget {
  final Function onMenuTap;

  const StatPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> with TickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
    final User user = auth.currentUser;

    return Consumer(
      builder: (context, watch, child) {

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
                    height: 16,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: GestureDetector(
                          onTap: widget.onMenuTap,
                          child: Container(
                            height: 30,
                              width: 30,
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
                      '${user.displayName}님 안녕하세요.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.yeonSung(
                          fontSize: 24, color: Colors.white),
                    )),
                  ),
                  SlidingCardsPage(auth),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Colors.blueGrey))),
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
