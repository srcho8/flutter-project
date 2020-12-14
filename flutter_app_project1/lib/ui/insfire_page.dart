import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:InsFire/faderoute.dart';
import 'package:InsFire/model/photo.dart';
import 'package:InsFire/provider/state_manager.dart';
import 'package:InsFire/ui/detail_memo_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsFirePage extends ConsumerWidget {
  final Function onMenuTap;

  InsFirePage({Key key, this.onMenuTap}) : super(key: key);

  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle = Text("InsFire");
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context, watch) {
    AsyncValue<List<Photos>> photos = watch(photoStateFuture);
    final iconState = watch(iconStateChangeNotifier);
    final searchKey = watch(keyProvider);

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.menu, color: Colors.white),
            onTap: onMenuTap,
          ),
          centerTitle: true,
          title: TextField(
            cursorColor: Colors.white,
            controller: _textController,
            onSubmitted: (String str) {
              if (str.isEmpty) {
                Flushbar(
                  title: "InsFire",
                  message: "테마 키워드를 입력하세요.",
                  duration: Duration(seconds: 1),
                )..show(context);
              } else {
                searchKey.state = str;
                _textController.clear();
              }
            },
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "테마 검색",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
          automaticallyImplyLeading: false,
        ),
        body: photos.when(
            data: (data) {
              return StaggeredGridView.countBuilder(
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
              );
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, s) => Center(
                  child: Text('${e.toString()}'),
                )));
  }
}

class NoKeyboardEditableTextState extends EditableTextState {
  @override
  void requestKeyboard() {
    super.requestKeyboard();
    //hide keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }
}
