import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/extentions/extentions.dart';
import 'package:flutter_app_project1/faderoute.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/ui/saved_memo_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

// holidays
final Map<DateTime, List> _holidays = {};

class CalendarPage extends StatefulWidget {
  final Function onMenuTap;

  const CalendarPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  List<Memo> _memoList;
  Map<DateTime, List> _events;
  List _selectedEvents;
  List<Memo> _selects;
  AnimationController _animationController;
  CalendarController _calendarController;
  int _selectedDrawerIndex;

  List<Widget> _getAppbarItemWidget(int pos) {
    switch (pos) {
      case 0:
        return <Widget>[
          _buildTableCalendarWithBuilders(),
          Container(
            height: 1,
            color: Colors.blueGrey,
          ),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ];
      case 1:
        return <Widget>[Expanded(child: _stickyList())];
    }
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _memoList = [];
    _events = {};
    _selects = [];
    setState(() {
      _fetchList().then((value) => _events = value);
      DBHelper().getAllMemos().then((value) => _memoList = value);
    });
    _selectedDrawerIndex = 1;

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Future<Map<DateTime, List>> _fetchList({DateTime day}) async {
    _memoList = await DBHelper().getAllMemos();

    if (day != null) {
      _selects = _memoList
          .where((v) {
            var tdate = DateTime(day.year, day.month, day.day).toString();
            var sdate = DateTime(
                    ToDate(v.datetime).stringToDate().year,
                    ToDate(v.datetime).stringToDate().month,
                    ToDate(v.datetime).stringToDate().day)
                .toString();

            return tdate == sdate;
          })
          .map((e) => e)
          .toList();
    }

    if (_memoList == null) {
      return {};
    } else {
      _events = Map.fromIterable(_memoList,
          key: (v) => DateTime(
              ToDate(v.datetime).stringToDate().year,
              ToDate(v.datetime).stringToDate().month,
              ToDate(v.datetime).stringToDate().day),
          value: (v) {
            var tdate = DateTime(
                ToDate(v.datetime).stringToDate().year,
                ToDate(v.datetime).stringToDate().month,
                ToDate(v.datetime).stringToDate().day);
            return _memoList
                .where((e) =>
                    DateTime(
                        ToDate(e.datetime).stringToDate().year,
                        ToDate(e.datetime).stringToDate().month,
                        ToDate(e.datetime).stringToDate().day) ==
                    tdate)
                .map((e) => e.title) // 여기서 변환
                .toList();
          });

      return _events;
    }
  }

  void _onDaySelected(DateTime day, List holidays, List<Memo> _memoList) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selects = _memoList
          .where((v) {
            var tdate = DateTime(day.year, day.month, day.day).toString();
            var sdate = DateTime(
                    ToDate(v.datetime).stringToDate().year,
                    ToDate(v.datetime).stringToDate().month,
                    ToDate(v.datetime).stringToDate().day)
                .toString();

            return tdate == sdate;
          })
          .map((e) => e)
          .toList();
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Icon actionIcon = new Icon(Icons.calendar_today_rounded);
  Widget appBarTitle = new Text("InsFire Box");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            child: Icon(Icons.menu, color: Colors.white),
            onTap: widget.onMenuTap,
          ),
          title: Text('InsFire Box'),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.calendar_today_rounded) {
                    this.actionIcon = new Icon(Icons.inbox);
                    _selectedDrawerIndex = 0;
                  } else {
                    this.actionIcon = new Icon(Icons.calendar_today_rounded);
                    _selectedDrawerIndex = 1;
                  }
                });
              },
            ),
          ]),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: _getAppbarItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return FutureBuilder(
        future: _fetchList(),
        builder: (context, snap) {
          return TableCalendar(
            locale: 'ko-KR',
            calendarController: _calendarController,
            events: _events,
            holidays: _holidays,
            initialCalendarFormat: CalendarFormat.month,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableGestures: AvailableGestures.all,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
              CalendarFormat.twoWeeks: '',
              CalendarFormat.week: '',
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendStyle: TextStyle().copyWith(color: Colors.redAccent),
              holidayStyle: TextStyle().copyWith(color: Colors.redAccent),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle().copyWith(color: Colors.redAccent),
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false,
            ),
            builders: CalendarBuilders(
              dayBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: _basicColor(events),
                  width: 100,
                  height: 100,
                  child: Text('${date.day}'),
                );
              },
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    color: Colors.blue[300],
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0),
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: Colors.amber[400],
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                );
              },
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    ),
                  );
                }

                if (holidays.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: -2,
                      top: -2,
                      child: _buildHolidaysMarker(),
                    ),
                  );
                }

                return children;
              },
            ),
            onDaySelected: (date, events, holidays) {
              _onDaySelected(date, holidays, _memoList);
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          );
        });
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Color _basicColor(List events) {
    int _step = 0;
    int _countEvents = 0;

    if (events != null) {
      _countEvents = events.length;
    }

    if (_countEvents == 0) {
      return Colors.white;
    } else if (_countEvents == 1) {
      return Colors.blueGrey[50];
    } else if (_countEvents > 1 && _countEvents < 5) {
      return Colors.blueGrey[100];
    } else {
      //_step = 100 * events.length;
      return Colors.blueGrey[300];
    }
  }

  Widget _buildEventList() {
    return FutureBuilder(
        future: _fetchList(),
        builder: (context, snap) {
          return ListView(
            children: _selects
                .map((event) => Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: InkWell(
                        onTap: () {
                          DBHelper().getMemo(event.id).then((value) =>
                              Navigator.push(context,
                                  FadeRoute(page: SavedMemoPage(value))));
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 8, right: 4),
                            alignment: Alignment.centerLeft,
                            child: Text(event.title)),
                      ),
                    ))
                .toList(),
          );
        });
  }

  Widget _stickyList() {
    setState(() {
      _fetchList();
    });

    return FutureBuilder(
        future: _fetchList(),
        builder: (context, snap) {
          return StickyGroupedListView<Memo, DateTime>(
            elements: _memoList,
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
            floatingHeader: false,
            groupSeparatorBuilder: (Memo element) => Container(
              height: 40,
              child: Row(
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
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  child: Container(
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Hero(
                              tag: element.id,
                              child: Image.memory(
                                  Base64Codec().decode(element.imageurl)))),
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
                ),
              );
            },
          );
        });
  }
}
