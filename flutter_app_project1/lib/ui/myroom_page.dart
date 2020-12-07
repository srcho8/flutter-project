import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/home_page_background.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class StatPage extends StatefulWidget {
  final Function onMenuTap;

  const StatPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      HomePageBackground(
        screenHeight: MediaQuery.of(context).size.height,
      ),
      Consumer(
        builder: (context, watch, child) {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          child: Icon(Icons.menu, color: Colors.white),
                          onTap: widget.onMenuTap,
                        ),
                        Text("My Room",
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
                        Icon(Icons.settings, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 50),
                    Container(
                      height: 200,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.8),
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.redAccent,
                            width: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.blueAccent,
                            width: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.greenAccent,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Transactions",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Macbook"),
                          subtitle: Text("Apple"),
                          trailing: Text("-2900"),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(height: 16);
                      },
                      itemCount: 10,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      )
    ]);
  }
}
