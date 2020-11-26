import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/provider/provider_homepage.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  void initState() {
    super.initState();
    DBHelper().initDB();
  }

  @override
  Widget build(BuildContext context) {
    final FirstPageIndex _firstPageIndex = Provider.of<FirstPageIndex>(context);

    void _onItemTapped(int index) {
      setState(() {
        _firstPageIndex.f_index = index;
      });
    }

    return Scaffold(
      body: Center(
        child: _firstPageIndex.widgetOptions.elementAt(_firstPageIndex.f_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartBar),
            label: 'Stat',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fireAlt),
            label: 'InsFire',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Mine',
          ),
        ],
        currentIndex: _firstPageIndex.f_index,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
