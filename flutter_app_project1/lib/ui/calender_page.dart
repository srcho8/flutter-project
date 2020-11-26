import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/extentions/extentions.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {};

class CalenderPage extends StatefulWidget {
  CalenderPage() : super();

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage>
    with TickerProviderStateMixin {
  List<Memo> _memoList;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    //_fetchList().then((value) => _events = value);

    _events = {
      DateTime(2020, 11, 24):['asd']
    };

    // _events = {
    //   _selectedDay.subtract(Duration(days: 1)): [
    //     'Event A0',
    //     'Event B0',
    //     'Event C0'
    //   ],
    //   _selectedDay.subtract(Duration(days: 1)): ['Event A1'],
    //   _selectedDay.subtract(Duration(days: 3)): [
    //     'Event A2',
    //     'Event B2',
    //     'Event C2',
    //     'Event D2'
    //   ],};


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

    if (_memoList == null) {
      _events = {};
    } else {
      var a = _memoList.map((e) => e.datetime).toSet().toList();
      var b = _memoList.map((e) {
        final DateFormat formatter = DateFormat('yyyy.MM.dd');
        final String formatted = formatter.format(ToDate(e.datetime).stringToDate());
        print(formatted);
      });

      return Map.fromIterable(
          _memoList, key: (v) => ToDate(v.datetime).stringToDate(),
          value: (v) => _memoList.map((e) => e.title).toList());
    }
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last,
      CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last,
      CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InsFire Box'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendarWithBuilders(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
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
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
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
          .map((event) =>
          Container(
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
}
