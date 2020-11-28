import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:url_launcher/url_launcher.dart';

class ModifyMemoPage extends StatefulWidget {
  final Memo memo;

  ModifyMemoPage(this.memo);

  @override
  _ModifyMemoPageState createState() => _ModifyMemoPageState();
}

class _ModifyMemoPageState extends State<ModifyMemoPage> {
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
        actions: [
          IconButton(
              icon: Image.asset('images/pexels.png'),
              iconSize: 80,
              onPressed: () {
                String url = 'https://www.pexels.com';
                _launchInWebViewOrVC(url);
              })
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: Hero(
                  tag: 'tt',
                  child:
                  Image.memory(Base64Codec().decode(widget.memo.imageurl))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      labelText: 'Title',
                    ),
                  ),
                  Container(
                    height: 200,
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        labelText: 'Enter your InsFire',
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
                          child: Text('저장'),
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
