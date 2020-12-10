import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/ui/posting_page_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PostingPage extends StatefulWidget {
  final Memo memo;

  PostingPage(this.memo);

  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();

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
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUsers(String id, String title, String contents, String image) {
      return users
          .doc(id)
          .set({
            'title': title,
            'contents': contents,
            'imgUrl' : image,
          })
          .then((value) => print("Users Added"))
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
                  padding: const EdgeInsets.only(left :16, right: 16),
                  child: Card(
                    elevation: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87,width: 8)
                      ),
                      child: Hero(
                        tag: widget.memo.id,
                        child: Image.network(widget.memo.large),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                        labelText: 'Title',
                      ),
                    ),
                    Container(
                      height: 250,
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 16,
                          ),
                          labelText: 'Enter your InsFire',
                        ),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                            child: Text('취소',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        OutlinedButton(
                            child: Text('업로드',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              addUsers(
                                  'srcho',
                                  _titleController.text,
                                  _contentController.text,
                                  widget.memo.large
                              )
                                  .then((value) {
                                Navigator.pop(this.context,
                                    PopValue('online'));
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

class PopValue {
  String type;
  Memo updatedMemo;

  PopValue(this.type, {this.updatedMemo});
}
