import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';

class SlidingCardsPage extends StatefulWidget {
  @override
  _SlidingCardsPageState createState() => _SlidingCardsPageState();
}

class _SlidingCardsPageState extends State<SlidingCardsPage> {
  PageController pageController;
  double pageOffset = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final streamPosts = watch(streamFirestoreMine);

      return streamPosts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(err.toString())),
          data: (snapshot) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: PageView(
                  controller: pageController,
                  children: snapshot.docs
                      .asMap()
                      .map((i, e) => MapEntry(
                          i,
                          SlidingCard(
                              title: e.data()['title'],
                              contents: e.data()['contents'],
                              date: DateFormat('yyyy-MM-dd \n    hh:mm:ss')
                                  .format(e.data()['datetime'].toDate())
                                  .toString(),
                              assetName: e.data()['imgUrl'],
                              offset: pageOffset - i.toDouble(),
                              likes: 12)))
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
  final String date;
  final String assetName;
  final double offset;
  final int likes;

  const SlidingCard(
      {Key key,
      @required this.title,
      @required this.contents,
      @required this.date,
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
              child: ExtendedImage.network(
                assetName,
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.cover,
                cache: true,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                title: title,
                contents: contents,
                likes: likes,
                date: date,
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
  final String date;
  final double offset;
  final int likes;

  const CardContent(
      {Key key,
      @required this.title,
      @required this.contents,
      @required this.date,
      @required this.offset,
      this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              contents,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
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
                          Icons.thumb_up_rounded,
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
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  '${date.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
