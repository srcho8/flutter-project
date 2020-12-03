import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/detail_memo_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsFirePage extends ConsumerWidget {
  final Function onMenuTap;

  InsFirePage({Key key, this.onMenuTap}) : super(key: key);

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("InsFire");
  final TextEditingController _textController = new TextEditingController();
  final iconProvider = ChangeNotifierProvider<IconStateChangeNotifier>((ref) {
    return IconStateChangeNotifier();
  });

  @override
  Widget build(BuildContext context, watch) {
    AsyncValue<List<Photos>> photos = watch(photoStateFuture);
    final iconState = watch(iconProvider);
    final searchKey = watch(keyProvider);

    return Scaffold(
        body: photos.when(
            data: (data) {
              return CustomScrollView(slivers: [
                SliverAppBar(
                    centerTitle: true,
                    title: appBarTitle,
                    floating: true,
                    automaticallyImplyLeading: false,
                    actions: <Widget>[
                      Builder(builder: (context) {
                        if (iconState.iconState == 0) {
                          return IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              this.actionIcon = new Icon(Icons.close);
                              this.appBarTitle = new TextField(
                                controller: _textController,
                                onSubmitted: (String str) {
                                  if (str.isEmpty) {
                                    Flushbar(
                                      title: "InsFire",
                                      message: "보고 싶은 사진 키워드를 입력하세요.",
                                      duration: Duration(seconds: 2),
                                    )..show(context);
                                  } else {
                                    searchKey.state = str;
                                  }
                                },
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: new InputDecoration(
                                    prefixIcon: new Icon(Icons.search,
                                        color: Colors.white),
                                    hintText: "Search",
                                    hintStyle:
                                        new TextStyle(color: Colors.white)),
                              );
                              iconState.change(1);
                              print(iconState.iconState.toString());
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              this.actionIcon = new Icon(Icons.search);
                              this.appBarTitle = new Text("InsFire");
                              _textController.clear();
                              iconState.change(0);
                              print(iconState.iconState.toString());
                            },
                          );
                        }
                      }),
                    ]),
                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 4,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Hero(
                          tag: data[index].id,
                          child: Image.network(
                            data[index].src.medium,
                            fit: BoxFit.cover,
                          )),
                      onTap: () {
                        Navigator.push(
                            context, FadeRoute(page: DetailPage(data[index])));
                      },
                    );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                )
              ]);
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, s) => Center(
                  child: Text('${e.toString()}'),
                )));
  }
}
