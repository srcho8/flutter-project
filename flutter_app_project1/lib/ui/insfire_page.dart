import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/repository/pexelsrepo.dart';
import 'package:flutter_app_project1/ui/detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../faderoute.dart';

class InsFirePage extends StatefulWidget {
  @override
  _InsFirePageState createState() => _InsFirePageState();
}

class _InsFirePageState extends State<InsFirePage> {
  List<Photos> Items = [];

  @override
  void initState() {
    super.initState();

    PexelsRepo().fetchPhotos().then((photos) {
      setState(() {
        Items = photos;
      });
    });
  }

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("InsFire");
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            title: appBarTitle,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              new IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = new Icon(Icons.close);
                      this.appBarTitle = new TextField(
                        controller: _textController,
                        onSubmitted: (String str) {
                            PexelsRepo().searchPhotos(_textController.text).then((value) {
                              setState(() {
                                Items = value;
                              });
                            });
                        },
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.white),
                            hintText: "Search",
                            hintStyle: new TextStyle(color: Colors.white)),
                      );
                    } else {
                      this.actionIcon = new Icon(Icons.search);
                      this.appBarTitle = new Text("InsFire");
                    }
                  });
                },
              ),
            ]),
        body: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: Items.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Hero(
                  tag: Items[index].id,
                  child: Image.network(Items[index].src.medium)),
              onTap: () {
                Navigator.push(
                    context, FadeRoute(page: DetailPage(Items[index])));
              },
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }
}
