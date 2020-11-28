import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedMemoPage extends StatefulWidget {
  final Memo memo;

  SavedMemoPage(this.memo);

  @override
  _SavedMemoPageState createState() => _SavedMemoPageState();
}

class _SavedMemoPageState extends State<SavedMemoPage> {
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();
  String _base64;
  Uint8List _url;

  Future<List<Memo>> _getMember() async {
    final List<Memo> maps = await DBHelper().getAllMemos();
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i].id,
        title: maps[i].title,
        contents: maps[i].contents,
      );
    });
  }

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
              child: Hero(
                  tag: widget.memo.id,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.memory(
                          Base64Codec().decode(widget.memo.imageurl)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
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
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              child: Text('닫기'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          OutlinedButton(
                              child: Text('수정'),
                              onPressed: () {
                                DBHelper().updateMemo((Memo(
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  id: widget.memo.id,
                                )));

                                Navigator.pop(this.context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
