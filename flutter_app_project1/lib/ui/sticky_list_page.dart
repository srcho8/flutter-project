import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/ui/saved_memo_page.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter_app_project1/extentions/extentions.dart';

class StickyListPage extends StatefulWidget {
  final Function onMenuTap;

  const StickyListPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _StickyListPageState createState() => _StickyListPageState();
}

class _StickyListPageState extends State<StickyListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DBHelper().getAllMemosStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  child: Icon(Icons.menu, color: Colors.white),
                  onTap: widget.onMenuTap,
                ),
                centerTitle: true,
                title: Text('Daily Inbox'),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.white,
                      ),
                      onPressed: null)
                ],
              ),
              body: StickyGroupedListView<Memo, DateTime>(
                elements: snapshot.data,
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
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                  return InkWell(
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
                        duration: Duration(seconds: 1),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeRoute(page: SavedMemoPage(element)),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 4.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Hero(
                                tag: element.id,
                                child: Image.network(element.imageurl))),
                        title: Text(element.title),
                        subtitle: Text(
                          element.contents,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                            '${element.datetime.stringToDate().hour}:${element.datetime.stringToDate().minute}'),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
