import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project1/provider/provider_homepage.dart';
import 'package:google_fonts/google_fonts.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class StatPage extends StatefulWidget with NavigationStates {
  final Function onMenuTap;

  const StatPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

@override
void initState() {}

class _StatPageState extends State<StatPage>
    with SingleTickerProviderStateMixin {
  //FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Card(
            child: Text('Hello'),
          )
        ],
      ),
    );
  }
}
