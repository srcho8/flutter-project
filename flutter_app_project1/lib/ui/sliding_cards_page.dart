import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/board_page.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SlidingCardsPage extends StatefulWidget {
  SlidingCardsPage(this.auth);

  final auth;

  @override
  _SlidingCardsPageState createState() => _SlidingCardsPageState();
}

class _SlidingCardsPageState extends State<SlidingCardsPage> {
  PageController pageController;
  double pageOffset = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final streamFireStoreMine = StreamProvider<QuerySnapshot>((ref) {
    Stream mine = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datetime', descending: true)
        .snapshots(includeMetadataChanges: true);
    return mine;
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final streamPosts = watch(streamFireStoreMine);

      return streamPosts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(err.toString())),
          data: (snapshot) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.52,
              child: PageView(
                  controller: pageController,
                  children: snapshot.docs
                      .where((element) =>
                          element.data()['uid'] == _auth.currentUser.uid)
                      .toList()
                      .asMap()
                      .map((i, e) {
                        var likes = e.data()['likes'];
                        return MapEntry(
                            i,
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(page: BoardPage(e)),
                                );
                              },
                              child: SlidingCard(
                                  title: e.data()['title'],
                                  contents: e.data()['contents'],
                                  assetName: e.data()['imgUrl'],
                                  offset: pageOffset - i,
                                  likes: likes.length),
                            ));
                      })
                      .values
                      .toList()),
            );
          });
    });
  }
}

class SlidingCard extends StatelessWidget {
  final String title;
  final String contents;
  final String assetName;
  final double offset;
  final int likes;

  const SlidingCard(
      {Key key,
      @required this.title,
      @required this.contents,
      @required this.assetName,
      @required this.offset,
      this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Hero(
                tag: '${title}_${contents}',
                child: ExtendedImage.network(
                  assetName,
                  height: MediaQuery.of(context).size.height * 0.3,
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.cover,
                  cache: true,
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                title: title,
                contents: contents,
                likes: likes,
                offset: gauss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String title;
  final String contents;
  final double offset;
  final int likes;

  const CardContent(
      {Key key,
      @required this.title,
      @required this.contents,
      @required this.offset,
      this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.yeonSung(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('$likes')
                      ],
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
