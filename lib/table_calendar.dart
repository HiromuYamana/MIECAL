import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Table_Calendar extends StatelessWidget {
  const Table_Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalendarPage();
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final DateTime _now = DateTime.now();
  late final DateTime _firstDay = DateTime(_now.year - 1, _now.month, _now.day);
  late final DateTime _lastDay = DateTime(_now.year, _now.month + 1, 0);

  final List<String> _japaneseWeekdays = ['月', '火', '水', '木', '金', '土', '日'];
  final List<String> _englishWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(255, 207, 227, 230),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Image.asset(
                      'assets/onset_date.png',
                      height: screenHeight * 0.2,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      '発症日(table calendar)',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white10,
              child: TableCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                enabledDayPredicate: (day) {
                  final now = DateTime.now();
                  final today = DateTime.utc(now.year, now.month, now.day);
                  final dateToCheck = DateTime.utc(
                    day.year,
                    day.month,
                    day.day,
                  );
                  return dateToCheck.isBefore(
                    today.add(const Duration(days: 1)),
                  ); // const を追加
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    final formattedDate =
                        "${selectedDay.year}/${selectedDay.month}/${selectedDay.day}";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$formattedDate '),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(label: '閉じる', onPressed: () {}),
                      ),
                    );
                  }
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                calendarStyle: const CalendarStyle(
                  todayTextStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  disabledTextStyle: TextStyle(color: Colors.grey),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  titleTextFormatter: (date, locale) {
                    return '${date.year}/${date.month}';
                  },
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    final String englishDow = _englishWeekdays[day.weekday - 1];
                    final String japaneseDow =
                        _japaneseWeekdays[day.weekday - 1];

                    Color textColor = Colors.black;
                    if (day.weekday == DateTime.saturday) {
                      textColor = Colors.blue;
                    } else if (day.weekday == DateTime.sunday) {
                      textColor = Colors.red;
                    }

                    return Center(
                      child: Text(
                        '$japaneseDow($englishDow)',
                        style: TextStyle(color: textColor, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    size: 70,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/SufferLevelPage');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
