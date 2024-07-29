import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'schedule_handle.dart';
import 'specialthanksPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = window.locale;
  late TextTheme _textTheme;

  @override
  void initState() {
    super.initState();
    _locale = window.locale;
    _setTextTheme();
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      _setTextTheme();
    });
  }

  void _setTextTheme() {
    if (_locale.languageCode == 'zh') {
      _textTheme = GoogleFonts.notoSansTextTheme();
    } else if (_locale.languageCode == 'ja') {
      _textTheme = GoogleFonts.kosugiTextTheme();
    } else {
      _textTheme = GoogleFonts.oswaldTextTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: _textTheme,
      ),
      home: Builder(
        builder: (context) {
          return MyHomePage(
            title: S.of(context).title,
            onLocaleChange: _setLocale,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.onLocaleChange});
  final String title;
  final void Function(Locale) onLocaleChange;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> parts = [];
  String jsonString = "";
  bool isLoading = false;
  List<int> workdaysMTU = [];
  List<int> workdaysUTM = [];
  List<int> weekendsMTU = [];
  List<int> weekendsUTM = [];
  int? _selectedValue;
  int nextBus = 0;
  int intervalTime = 1;
  int countDown = 0;
  String nextBusStr = "";
  String countDownStr = "";
  String _selectedLanguage = window.locale.languageCode;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _selectedValue = 1;
    loadJSON().then((_) {
      ScheduleHandle sh = ScheduleHandle(jsonString);
      workdaysMTU = sh.workdaysMTU;
      workdaysUTM = sh.workdaysUTM;
      weekendsMTU = sh.weekendsMTU;
      weekendsUTM = sh.weekendsUTM;
      setState(() {});
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateData();
      setState(() {
        nextBusStr = secToStr(nextBus);
        countDownStr = secToStr(countDown);
      });
    });
  }

  void updateData() {
    final now = DateTime.now();
    int nowSec = now.hour * 3600 + now.minute * 60 + now.second;
    if (_selectedValue == 1) {
      if (now.weekday == 6 || now.weekday == 7) {
        for (int i = 0; i < weekendsMTU.length; i++) {
          if (weekendsMTU[i] > nowSec) {
            nextBus = weekendsMTU[i];
            intervalTime = i > 0 ? weekendsMTU[i] - weekendsMTU[i - 1] : weekendsMTU[i];
            countDown = weekendsMTU[i] - nowSec;
            break;
          }
        }
      } else {
        for (int i = 0; i < workdaysMTU.length; i++) {
          if (workdaysMTU[i] > nowSec) {
            nextBus = workdaysMTU[i];
            intervalTime = i > 0 ? workdaysMTU[i] - workdaysMTU[i - 1] : workdaysMTU[i];
            countDown = nextBus - nowSec;
            break;
          }
        }
      }
    } else {
      if (now.weekday == 6 || now.weekday == 7) {
        for (int i = 0; i < weekendsUTM.length; i++) {
          if (weekendsUTM[i] > nowSec) {
            nextBus = weekendsUTM[i];
            intervalTime = i > 0 ? weekendsUTM[i] - weekendsUTM[i - 1] : weekendsUTM[i];
            countDown = nextBus - nowSec;
            break;
          }
        }
      } else {
        for (int i = 0; i < workdaysUTM.length; i++) {
          if (workdaysUTM[i] > nowSec) {
            nextBus = workdaysUTM[i];
            intervalTime = i > 0 ? workdaysUTM[i] - workdaysUTM[i - 1] : workdaysUTM[i];
            countDown = nextBus - nowSec;
            break;
          }
        }
      }
    }
  }

  String secToStr(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;
    int seconds = sec % 60;

    String hoursStr = hours > 9 ? '$hours' : '0$hours';
    String minutesStr = minutes > 9 ? '$minutes' : '0$minutes';
    String secondsStr = seconds > 9 ? '$seconds' : '0$seconds';

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  Future<void> loadJSON() async {
    jsonString = await rootBundle.loadString("assets/Schedule_V.24.7.20.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      drawer: Drawer(
        child: ListView(
            padding: const EdgeInsets.all(64),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/app_logo.png'),
              ),
              Text(widget.title,
                style: Theme.of(context).textTheme.headlineLarge),
              Text(
                S.of(context).version,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                S.of(context).designedBy,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              ListTile(
                title: Text(S.of(context).chooseLanguage),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                      if (_selectedLanguage == 'en') {
                        widget.onLocaleChange(const Locale('en'));
                      } else if (_selectedLanguage == 'zh') {
                        widget.onLocaleChange(const Locale('zh'));
                      } else if (_selectedLanguage == 'ja') {
                        widget.onLocaleChange(const Locale('ja'));
                      }
                    });
                  },
                  items: <String>['en', 'zh', 'ja']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecialThanksPage()),
                    );
                  },
                child: const Text("Thanks Page",),
              )
            ]
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).nextBusTime,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              nextBusStr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).timeRemaining,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              countDownStr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 30,
              child: FAProgressBar(
                maxValue: 100,
                changeColorValue: 25,
                changeProgressColor: Colors.green,
                currentValue: (countDown / intervalTime * 100).toDouble(),
                displayText: '%',
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).locationSelection,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(S.of(context).location1,
                      style: Theme.of(context).textTheme.bodyLarge,),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20), // 添加间距
                Expanded(
                  child: ListTile(
                    title: Text(S.of(context).location2,
                      style: Theme.of(context).textTheme.bodyLarge,),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
