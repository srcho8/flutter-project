import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BoardPage extends StatefulWidget {
  BoardPage(this.posts);

  final QueryDocumentSnapshot posts;

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  var likeState;
  num _likes;
  final User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _likes = widget.posts.data()['likes'].length;
  }

  @override
  Widget build(BuildContext context) {
    var post =
        FirebaseFirestore.instance.collection('posts').doc(widget.posts.id);

    Stream _mine = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.posts.id)
        .snapshots(includeMetadataChanges: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag:
                  '${widget.posts.data()['title']}_${widget.posts.data()['contents']}',
              child: ExtendedImage.network(
                widget.posts.data()['largeImgUrl'],
                cache: true,
              ),
            ),
            Container(
              color: Colors.blueGrey[200],
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: _mine,
                        builder: (context, data) {
                          var likeUid = data.data.data()['likes'];
                          if (likeUid.where((element) => element == user.uid).length == 0) {
                            return GestureDetector(
                              onTap: (){
                                post.update({
                                  'likes': FieldValue.arrayUnion([user.uid])
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.thumb_up_outlined,
                                    color: Colors.blueGrey[700],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${likeUid.length}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: (){
                                post.update({
                                  'likes': FieldValue.arrayRemove([user.uid])
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.blueGrey[700],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${likeUid.length}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                widget.posts.data()['title'],
                style: GoogleFonts.yeonSung(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.posts.data()['username'],
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  width: 24,
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              widget.posts.data()['contents'],
              style: GoogleFonts.yeonSung(fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonBar(
                  children: [
                    OutlineButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '닫기',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 12,
                )
              ],
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
