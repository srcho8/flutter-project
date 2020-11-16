import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_confer_1/detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'faderoute.dart';
import 'model/confer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<Confer>> conf;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Conferences",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
        body: ConferPage(),
      ),
    );
  }

  Widget ConferPage() {
    return FutureBuilder<List<Confer>>(
      future: fetchConf(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ConferList(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<List<Confer>> fetchConf(http.Client client) async {
  var url =
      'https://raw.githubusercontent.com/junsuk5/mock_json/main/conferences.json';

  var response = await client.get(url);

  return compute(parseConf, response.body);
}

List<Confer> parseConf(String responseBody) {
  List a = jsonDecode(responseBody);

  return a.map((e) => Confer.fromJson(e)).toList();
}

class ConferList extends StatelessWidget {
  final List<Confer> confer;

  ConferList(this.confer);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: confer
              .map((e) => ListTile(
                    title: Text(e.name),
                    subtitle: Text(e.location),
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: Detail(e)));
                    },
                  ))
              .toList(),
        ));
  }
}
