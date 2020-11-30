import 'dart:convert';
import 'dart:typed_data';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/ui/modify_memo_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Container(
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child:
                      Image.memory(Base64Codec().decode(widget.memo.imageurl))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 1,
                  width: 200,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    Container(
                      height: 304,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                widget.memo.title,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    height: 1,
                                    width: 100,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    widget.memo.contents,
                                    style: TextStyle(fontSize: 16),
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
                        OutlinedButton(
                            child: Text('닫기',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        OutlinedButton(
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
                                    duration: Duration(seconds: 2),
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
    );
  }
}
