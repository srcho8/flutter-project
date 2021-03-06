import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:InsFire/model/memo.dart';
import 'package:InsFire/ui/posting_page_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:google_fonts/google_fonts.dart';

class PostingPage extends StatefulWidget {
  final Memo memo;

  PostingPage(this.memo);

  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memo.title);
    _contentController = TextEditingController(text: widget.memo.contents);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser;
    CollectionReference post = FirebaseFirestore.instance.collection('posts');
    Future<void> addPost(
        String id,
        String title,
        String contents,
        String image,
        String miniImage,
        String uid,
        String largeImage) {
      return post
          .add({
            'uid': uid,
            'username': id,
            'title': title,
            'contents': contents,
            'imgUrl': image,
            'miniImgUrl': miniImage,
            'largeImgUrl': largeImage,
            'likes': [],
            'datetime': DateTime.now()
          })
          .then((value) => print("Post Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
        body: Stack(
      children: [
        PostingPageBackground(screenHeight: MediaQuery.of(context).size.height),
        SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    elevation: 16,
                    child: Hero(
                      tag: widget.memo.id,
                      child: ExtendedImage.network(
                        widget.memo.large,
                        cache: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${_titleController.text}',
                      style: GoogleFonts.yeonSung(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${_contentController.text}',
                      style: GoogleFonts.yeonSung(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                            child: Text('닫기',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        OutlinedButton(
                            child: Text('업로드',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              addPost(user.displayName,
                                      _titleController.text,
                                      _contentController.text,
                                      widget.memo.landscape,
                                      widget.memo.tiny,
                                      user.uid,
                                      widget.memo.large)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ))
      ],
    ));
  }
}
