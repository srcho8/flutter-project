import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InsFire'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
