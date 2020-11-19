import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/repository/pexelsrepo.dart';

class InsFirePage extends StatefulWidget {
  @override
  _InsFirePageState createState() => _InsFirePageState();
}

class _InsFirePageState extends State<InsFirePage> {
  List<Photos> photos = [];

  @override
  void initState() {
    super.initState();

    PexelsRepo().fetchPhotos().then((value) {
      setState(() {
        photos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InsFire'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
          children: photos.map((e) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.network(
              e.src.tiny,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {},
        );
      }).toList()),
    );
  }
}
