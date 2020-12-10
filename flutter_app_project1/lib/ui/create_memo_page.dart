import 'dart:convert';
import 'dart:typed_data';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_project1/model/photo.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MemoPage extends StatefulWidget {
  final Photos photos;

  MemoPage(this.photos);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  @override
  void initState() {
    super.initState();
    original = widget.photos.src.original;
    large2x = widget.photos.src.large2x;
    large = widget.photos.src.large;
    medium = widget.photos.src.medium;
    small = widget.photos.src.small;
    portrait = widget.photos.src.portrait;
    landscape = widget.photos.src.landscape;
    tiny = widget.photos.src.tiny;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Center(
                child: Hero(
                    tag: widget.photos.id,
                    child: Image.network(
                      widget.photos.src.tiny,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      labelText: 'Title',
                    ),
                  ),
                  Container(
                    height: 300,
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
                          child:
                              Text('닫기', style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      OutlinedButton(
                          child:
                              Text('저장', style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            if (_titleController.text.isEmpty) {
                              Flushbar(
                                title: "InsFire",
                                message: "제목이 비어있어요.",
                                duration: Duration(seconds: 2),
                              )..show(context);
                            } else {
                              DBHelper().createData((Memo(
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  original: original,
                                  large2x: large2x,
                                  large: large,
                                  small: small,
                                  medium: medium,
                                  portrait: portrait,
                                  landscape: landscape,
                                  tiny: tiny,
                                  datetime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime.now()),
                                  selected: 0)));

                              Navigator.pop(this.context, 'saved');
                            }
                          }),
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
