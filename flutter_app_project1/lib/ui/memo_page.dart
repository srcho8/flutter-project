import 'dart:convert';
import 'dart:typed_data';

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
  String _base64;
  Uint8List _url;

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(
        widget.photos.src.tiny,
      );
      if (mounted) {
        setState(() {
          _base64 = Base64Codec().encode(response.bodyBytes);
          _url = Base64Codec().decode(_base64);
        });
      }
    })();
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
                  tag: widget.photos.id,
                  child: Image.network(
                    widget.photos.src.tiny,
                    fit: BoxFit.cover,
                  )),
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
                      OutlineButton(
                          child: Text('닫기'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      OutlineButton(
                          child: Text('저장'),
                          onPressed: () {
                            DBHelper().createData((Memo(
                                title: _titleController.text,
                                contents: _contentController.text,
                                imageurl: _base64,
                                datetime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(DateTime.now()))));

                            Navigator.pop(this.context, 'saved');
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
