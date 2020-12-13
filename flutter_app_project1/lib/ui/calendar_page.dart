import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:InsFire/db/database_helper.dart';
import 'package:InsFire/extentions/extentions.dart';
import 'package:InsFire/faderoute.dart';
import 'package:InsFire/model/memo.dart';
import 'package:InsFire/provider/state_manager.dart';
import 'package:InsFire/ui/saved_memo_page.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

// holidays
final Map<DateTime, List> _holidays = {};

class CalendarPage extends StatefulWidget {
  final Function onMenuTap;

  CalendarPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  List<Memo> _memoList = [];
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  List<Memo> _selects = [];
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(Icons.menu, color: Colors.white),
            onTap: widget.onMenuTap,
          ),
          title: Text('InsFire Calendar'),
          centerTitle: true,
        ),
        body: Consumer(builder: (context, watch, child) {
          AsyncValue<List<Memo>> memos = watch(memoFetchListState);

          return memos.when(
              data: (data) {
                _memoList = data;
                _events = Map.fromIterable(data,
                    key: (v) => DateTime(
                        ToDate(v.datetime).stringToDate().year,
                        ToDate(v.datetime).stringToDate().month,
                        ToDate(v.datetime).stringToDate().day),
                    value: (v) {
                      var tdate = DateTime(
                          ToDate(v.datetime).stringToDate().year,
                          ToDate(v.datetime).stringToDate().month,
                          ToDate(v.datetime).stringToDate().day);
                      return data
                          .where((e) =>
                              DateTime(
                                  ToDate(e.datetime).stringToDate().year,
                                  ToDate(e.datetime).stringToDate().month,
                                  ToDate(e.datetime).stringToDate().day) ==
                              tdate)
                          .map((e) => e.title) // 여기서 변환
                          .toList();
                    });

                return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildTableCalendarWithBuilders(),
                      Container(
                        height: 1,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(child: _buildEventList()),
                    ]);
              },
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              error: (e, s) => Center(
                    child: Text('${e.toString()}'),
                  ));
        }));
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

  Widget _buildTableCalendarWithBuilders() {
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
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
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
    return ListView(
      children: _selects
          .map((event) => Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8, color: Colors.grey[400]),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: InkWell(
                  onTap: () {
                    DBHelper().getMemo(event.id).then((value) => Navigator.push(
                        this.context, FadeRoute(page: SavedMemoPage(value))));
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 8, right: 4),
                      alignment: Alignment.centerLeft,
                      child: Text(event.title)),
                ),
              ))
          .toList(),
    );
  }
}
