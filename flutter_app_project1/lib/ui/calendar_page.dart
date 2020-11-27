import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/extentions/extentions.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:grouped_list/grouped_list.dart';

// Example holidays
final Map<DateTime, List> _holidays = {};

class CalendarPage extends StatefulWidget {
  CalendarPage() : super();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  List<Memo> _memoList;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  List<Widget> _getAppbarItemWidget(int pos) {
    switch (pos) {
      case 0:
        return <Widget>[
          _buildTableCalendarWithBuilders(),
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

    setState(() {
      _fetchList().then((value) => _events = value);
    });

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Future<Map<DateTime, List>> _fetchList() async {
    _memoList = await DBHelper().getAllMemos();

    _memoList.map((e) => print(e));

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

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
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

  Icon actionIcon = new Icon(Icons.inbox);
  Widget appBarTitle = new Text("InsFire Box");
  int _selectedDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('InsFire Box'),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.inbox) {
                    this.actionIcon = new Icon(Icons.calendar_today_rounded);
                    _selectedDrawerIndex = 1;
                  } else {
                    this.actionIcon = new Icon(Icons.inbox);
                    _selectedDrawerIndex = 0;
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
              _onDaySelected(date, events, holidays);
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          );
        });
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  Widget _stickyList() {
    setState(() {
      _fetchList();
    });

    List<Element> _elements = _memoList
        .map((e) => Element(
            DateTime(
                ToDate(e.datetime).stringToDate().year,
                ToDate(e.datetime).stringToDate().month,
                ToDate(e.datetime).stringToDate().day,
                ToDate(e.datetime).stringToDate().hour,
                ToDate(e.datetime).stringToDate().minute),
            e.title,
            e.contents, e.imageurl))
        .toList();

    return StickyGroupedListView<Element, DateTime>(
      elements: _elements,
      order: StickyGroupedListOrder.DESC,
      groupBy: (Element element) =>
          DateTime(element.date.year, element.date.month, element.date.day),
      groupComparator: (DateTime value1, DateTime value2) =>
          value1.compareTo(value2),
      itemComparator: (Element element1, Element element2) =>
          element1.date.compareTo(element2.date),
      floatingHeader: false,
      groupSeparatorBuilder: (Element element) => Container(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${element.date.day}. ${element.date.month}, ${element.date.year}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (_, Element element) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 4.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Image.memory(Base64Codec().decode(element.url)),
              title: Text(element.title),
              subtitle: Text(
                element.contents,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text('${element.date.hour}:${element.date.minute}'),
            ),
          ),
        );
      },
    );
  }
}

class Element {
  DateTime date;
  String title;
  String contents;
  String url;

  Element(this.date, this.title, this.contents, this.url);
}
