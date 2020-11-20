import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/repository/pexelsrepo.dart';
import 'package:flutter_app_project1/ui/detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../faderoute.dart';

class InsFirePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('InsFire'),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<Photos>>(
            future: PexelsRepo().fetchPhotos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Hero(
                          tag: snapshot.data[index].id,
                          child:
                              Image.network(snapshot.data[index].src.medium)),
                      onTap: () {
                        Navigator.push(context,
                            FadeRoute(page: DetailPage(snapshot.data[index])));
                      },
                    );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
