import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/provider/state_manager.dart';
import 'package:flutter_app_project1/ui/saved_memo_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter_app_project1/extentions/extentions.dart';

class StickyListPage extends StatefulWidget {
  final Function onMenuTap;

  const StickyListPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StickyListPageState createState() => _StickyListPageState();
}

class _StickyListPageState extends State<StickyListPage> {
  Icon searchActionIcon = new Icon(Icons.search);
  Icon selectActionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Daily Inbox");
  final TextEditingController _textController = new TextEditingController();
  final searchIconProvider =
      ChangeNotifierProvider<StickySearchIconStateChangeNotifier>((ref) {
    return StickySearchIconStateChangeNotifier();
  });
  final selectIconProvider =
      ChangeNotifierProvider<StickySelectIconStateChangeNotifier>((ref) {
    return StickySelectIconStateChangeNotifier();
  });

  @override
  Widget build(BuildContext context) {
    var streamList = DBHelper().getAllMemosStream();

    return StreamBuilder(
        stream: streamList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer(
              builder: (context, watch, child) {
                var searchIcon = watch(searchIconProvider);
                var selectIcon = watch(selectIconProvider);

                List<Memo> myList = snapshot.data;
                myList = myList
                    .where((element) =>
                        element.title.contains(_textController.text))
                    .toList();

                final myListWatch = StateNotifierProvider(
                        (ref) => SearchInboxState(myList, _textController.text))
                    .state;
                final myWL = watch(myListWatch);

                return Scaffold(
                  appBar: AppBar(
                    leading: InkWell(
                      child: Icon(Icons.menu, color: Colors.white),
                      onTap: widget.onMenuTap,
                    ),
                    centerTitle: true,
                    title: appBarTitle,
                    actions: <Widget>[
                      Builder(builder: (context) {
                        if (searchIcon.iconState == 0) {
                          return IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              this.searchActionIcon = new Icon(Icons.close);
                              this.appBarTitle = new TextField(
                                controller: _textController,
                                onSubmitted: (String str) {
                                  if (str.isEmpty) {
                                    Flushbar(
                                      title: "InsFire",
                                      message: "검색할 키워드가 없습니다.",
                                      duration: Duration(seconds: 1),
                                    )..show(context);
                                  } else {
                                    setState(() {
                                      _textController.text = str;
                                    });
                                  }
                                },
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: new InputDecoration(
                                    prefixIcon: new Icon(Icons.search,
                                        color: Colors.white),
                                    hintText: "제목 검색",
                                    hintStyle:
                                        new TextStyle(color: Colors.white)),
                              );
                              searchIcon.change(1);
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              this.searchActionIcon = new Icon(Icons.search);
                              this.appBarTitle = new Text("Daily Inbox");
                              _textController.clear();
                              searchIcon.change(0);
                            },
                          );
                        }
                      }),
                    ],
                  ),
                  body: Column(
                    children: [
                      Builder(builder: (context) {
                        if (selectIcon.iconState == 0) {
                          return Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      selectIcon.change(1);
                                    },
                                    child: Text(
                                      '편집',
                                      style: TextStyle(color: Colors.black54),
                                    )),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${myWL.where((element) => element.selected == 1).length}개 선택됨',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              DBHelper()
                                                  .updateSelectedAllMemo();
                                            });
                                          },
                                          child: Text(
                                            '전체선택',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              DBHelper().deleteSelectedMemos();
                                              selectIcon.change(0);
                                            });
                                          },
                                          child: Text(
                                            '선택삭제',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                      Expanded(
                        child: StickyGroupedListView<Memo, DateTime>(
                          floatingHeader: false,
                          elements: myWL,
                          order: StickyGroupedListOrder.DESC,
                          groupBy: (Memo memo) {
                            var date = memo.datetime.stringToDate();
                            return DateTime(date.year, date.month, date.day);
                          },
                          groupComparator: (DateTime value1, DateTime value2) =>
                              value1.compareTo(value2),
                          itemComparator: (Memo element1, Memo element2) {
                            var date1 = element1.datetime.stringToDate();
                            var date2 = element2.datetime.stringToDate();
                            return date1.compareTo(date2);
                          },
                          groupSeparatorBuilder: (Memo element) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '${element.datetime.stringToDate().day}. ${element.datetime.stringToDate().month}, ${element.datetime.stringToDate().year}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          itemBuilder: (_, Memo element) {
                            return Card(
                              color: element.selected == 0
                                  ? null
                                  : Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              elevation: 4.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              child: ListTile(
                                onTap: () {
                                  if (selectIcon.iconState == 0) {
                                    Navigator.push(
                                      context,
                                      FadeRoute(page: SavedMemoPage(element)),
                                    );
                                  } else {
                                    setState(() {
                                      element.selected =
                                          element.selected == 0 ? 1 : 0;
                                      DBHelper().updateSelectedMemo(
                                          element.selected, element.id);
                                    });

                                    print('색칠');
                                  }
                                },
                                onLongPress: () {
                                  return showAnimatedDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return ClassicGeneralDialogWidget(
                                        titleText: '삭제',
                                        contentText: '삭제 하실래요?',
                                        onPositiveClick: () {
                                          setState(() {
                                            DBHelper().deleteMemo(element.id);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        onNegativeClick: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                    animationType: DialogTransitionType.size,
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(milliseconds: 300),
                                  );
                                },
                                selected: element.selected == 0 ? false : true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Hero(
                                        tag: element.id,
                                        child:
                                            Image.network(element.imageurl))),
                                title: Text(element.title),
                                subtitle: Text(
                                  element.contents,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                    '${element.datetime.stringToDate().hour}:${element.datetime.stringToDate().minute}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        });
  }
}
