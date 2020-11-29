import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
