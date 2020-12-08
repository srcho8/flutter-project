import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/ui/home_page_background.dart';
import 'package:flutter_app_project1/ui/scrollable_exhibition_bottom_sheet.dart';
import 'package:flutter_app_project1/ui/sliding_cards_page.dart';
import 'package:flutter_riverpod/all.dart';

class StatPage extends StatefulWidget {
  final Function onMenuTap;

  const StatPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser;

    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: widget.onMenuTap,
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            title: Text('${user.displayName}\'s Exhibition'),
          ),
          body: Stack(children: <Widget>[
            HomePageBackground(
              screenHeight: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70,),
                  SlidingCardsPage(),

                ],
              ),
            ),
            ScrollableExhibitionSheet(onMenuTap: widget.onMenuTap,),
          ]),
        );
      },
    );
  }
}
