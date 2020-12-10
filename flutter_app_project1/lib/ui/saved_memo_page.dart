import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/ui/modify_memo_page.dart';
import 'package:flutter_app_project1/ui/posting_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SavedMemoPage extends StatefulWidget {
  Memo memo;

  SavedMemoPage(this.memo);

  @override
  _SavedMemoPageState createState() => _SavedMemoPageState();
}

class _SavedMemoPageState extends State<SavedMemoPage> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_upload,
                color: Colors.amber[200],
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  FadeRoute(page: PostingPage(widget.memo)),
                );
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              child: Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                        tag: widget.memo.id,
                        child: Image.network(
                          widget.memo.tiny,
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 304,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Hero(
                                  tag:
                                      '${widget.memo.title}_${widget.memo.id}_title',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.memo.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    child: Hero(
                                      tag:
                                          '${widget.memo.contents}_${widget.memo.id}_contents',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          widget.memo.contents,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          // TextButton(
                          //     child: Text('닫기',
                          //         style: TextStyle(color: Colors.black)),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     }),
                          OutlineButton(
                              child: Text(
                                '수정',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(page: ModifyMemoPage(widget.memo)),
                                ).then((value) {
                                  if (value.type == 'modifyed') {
                                    setState(() {
                                      widget.memo = value.updatedMemo;
                                    });
                                    Flushbar(
                                      title: "InsFire",
                                      message: "수정했어요.",
                                      duration: Duration(seconds: 1),
                                    )..show(context);
                                  } else if (value.type == 'online') {
                                    Flushbar(
                                      title: "InsFire",
                                      message: "공유 완료했어요.",
                                      duration: Duration(seconds: 1),
                                    )..show(context);
                                  }
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
