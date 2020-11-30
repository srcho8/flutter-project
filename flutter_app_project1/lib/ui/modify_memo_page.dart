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
                        child:
                            Text('닫기', style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    OutlinedButton(
                        child:
                            Text('저장', style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          DBHelper().updateMemo((Memo(
                            title: _titleController.text,
                            contents: _contentController.text,
                            id: widget.memo.id,
                          )));

                          DBHelper().getMemo(widget.memo.id).then((value) {
                            Navigator.pop(
                                this.context, PopValue('modifyed', value));
                          });
                        }),
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

class PopValue {
  String type;
  Memo updatedMemo;

  PopValue(this.type, this.updatedMemo);
}
