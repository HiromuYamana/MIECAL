import 'package:flutter/material.dart';
import 'package:miecal/suffer_level.dart'; // SufferLevelPage をインポート
import 'package:table_calendar/table_calendar.dart';
import 'package:miecal/vertical_slide_page.dart';
import 'package:miecal/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart'; // context.pop/push のために追加

class DatePage extends StatefulWidget {
  // DatePage が以前のページからデータを受け取る必要があればここに追加します
  final String? userName;
  final DateTime? userDateOfBirth;
  final String? userHome;
  final String? userGender;
  final String? userTelNum;
  final DateTime? selectedOnsetDay;
  final String? symptom;
  final String? affectedArea;
  final String? sufferLevel;
  final String? cause;
  final String? otherInformation;

  const DatePage({
    super.key,
    this.userName,
    this.userDateOfBirth,
    this.userHome,
    this.userGender,
    this.userTelNum,
    this.selectedOnsetDay,
    this.symptom,
    this.affectedArea,
    this.sufferLevel,
    this.cause,
    this.otherInformation,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DatePageState createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final DateTime _now = DateTime.now();
  // 現在の日付から1年前をfirstDayに設定 (年/月/日を考慮)
  late final DateTime _firstDay = DateTime(_now.year - 1, _now.month, _now.day);
  // 現在の月の最終日をlastDayに設定
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
    final loc = AppLocalizations.of(context)!;
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
                        context.pop(); // GoRouter の pop を使用
                      },
                    ),
                    Image.asset(
                      'assets/onset_date.png', // <-- 修正点: パスを 'assets/assets/' に変更
                      height: screenHeight * 0.16,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      loc.dateOfOnset,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
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
                  );
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
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
                    return '${date.year}年${date.month}月'; // フォーマットを「YYYY年M月」に戻す
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
            child: Material(
              color: Colors.blueGrey,
              child: InkWell(
                onTap: () {
                  // 選択された日付と、このページが受け取った過去のデータをSufferLevelPageに渡す
                  // 修正点: GoRouter の context.push を使用
                  context.push(
                    '/SufferLevelPage', // main.dart で定義されたパス
                    extra: {
                      // GoRouter の extra プロパティでデータを渡す
                      'userName': widget.userName,
                      'userDateOfBirth': widget.userDateOfBirth,
                      'userHome': widget.userHome,
                      'userGender': widget.userGender,
                      'userTelNum': widget.userTelNum,
                      'selectedOnsetDay': _selectedDay, // このページで選択された日付
                      'symptom': widget.symptom,
                      'affectedArea': widget.affectedArea,
                      'sufferLevel': widget.sufferLevel, // このページで選択した程度
                      'cause': widget.cause,
                      'otherInformation': widget.otherInformation,
                    },
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.arrow_downward,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
