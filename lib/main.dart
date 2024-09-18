import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'schedule_handle.dart';
import 'specialthanksPage.dart';
import 'schoolBusTablePage.dart';
import 'package:http/http.dart' as http;


/*
程序总入口
 */
void main() {
  runApp(const MyApp());
}

/*
MyApp继承StatefulWidget类
 */
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/*
MyApp的状态
 */
class _MyAppState extends State<MyApp> {
  Locale _locale = PlatformDispatcher.instance.locale;
  late TextTheme _textTheme;

  @override

  /*
  初始化状态
   */
  void initState() {
    super.initState();
    _locale = PlatformDispatcher.instance.locale;
    _setTextTheme();
  }

  /*
  设置语言和地区本地化内容
   */
  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      _setTextTheme();
    });
  }

  /*
  设置不同字体的样式
   */
  void _setTextTheme() {
    if (_locale.languageCode == 'zh') {
      _textTheme = GoogleFonts.notoSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.notoSans(fontSize: 54.0, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.notoSans(fontSize: 24.0, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.notoSans(fontSize: 36.0, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.notoSans(fontSize: 24.0, fontWeight: FontWeight.w600),
        bodyMedium: GoogleFonts.notoSans(fontSize: 18.0, fontWeight: FontWeight.w600),
        labelLarge: GoogleFonts.notoSans(fontSize: 14.0),
        labelMedium: GoogleFonts.notoSans(fontSize: 36.0, fontWeight: FontWeight.w700)
      );

    } else if (_locale.languageCode == 'ja') {
      _textTheme = GoogleFonts.kosugiTextTheme().copyWith(
        headlineLarge: GoogleFonts.notoSans(fontSize: 54.0, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.notoSans(fontSize: 24.0, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.notoSans(fontSize: 36.0, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.notoSans(fontSize: 24.0, fontWeight: FontWeight.w600),
        bodyMedium: GoogleFonts.notoSans(fontSize: 18.0, fontWeight: FontWeight.w600),
        labelLarge: GoogleFonts.notoSans(fontSize: 14.0),
        labelMedium: GoogleFonts.notoSans(fontSize: 22.0, fontWeight: FontWeight.w700)
      );;
    } else {
      _textTheme = GoogleFonts.oswaldTextTheme().copyWith(
        headlineLarge: GoogleFonts.notoSans(fontSize: 54.0, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.notoSans(fontSize: 24.0, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.notoSans(fontSize: 36.0, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.notoSans(fontSize: 20.0, fontWeight: FontWeight.w600),
        bodyMedium: GoogleFonts.notoSans(fontSize: 18.0, fontWeight: FontWeight.w600),
        labelLarge: GoogleFonts.notoSans(fontSize: 14.0),
        labelMedium: GoogleFonts.notoSans(fontSize: 18.0, fontWeight: FontWeight.w700)
      );;
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
  int operationCode = 0;
  int intervalTime = 1;
  int countDown = 0;
  String nextBusStr = "";
  String countDownStr = "";
  String _selectedLanguage = PlatformDispatcher.instance.locale.languageCode;
  bool isNextBus = true;

  late Timer _timer;

  final List<bool> _selectedLocation = <bool>[true, false];

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
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateData();
      setState(() {
        nextBusStr = secToStr(nextBus);
        countDownStr = countdownToStr(countDown);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();  // 确保销毁时计时器被取消
    super.dispose();
  }

  // void updateData() {
  //   final now = DateTime.now();
  //   int nowSec = now.hour * 3600 + now.minute * 60 + now.second;
  //   if (_selectedValue == 1) {
  //     if (now.weekday == 6 || now.weekday == 7) {
  //       for (int i = 0; i < weekendsMTU.length; i++) {
  //         if (0 <= (i + operationCode) && (i + operationCode) < weekendsMTU.length){
  //           if (weekendsMTU[i] > nowSec) {
  //             nextBus = weekendsMTU[i + operationCode];
  //             intervalTime = i + operationCode > 0 ? weekendsMTU[i + operationCode] - weekendsMTU[i + operationCode - 1] : weekendsMTU[i + operationCode];
  //             countDown = weekendsMTU[i + operationCode] - nowSec;
  //             break;
  //           }
  //         }else{
  //           operationCode = (i + operationCode) < 0 ? operationCode + 1 : weekendsMTU.length - 1;
  //         }
  //       }
  //     } else {
  //       for (int i = 0; i < workdaysMTU.length; i++) {
  //         print(i + operationCode);
  //         if (0 <= (i + operationCode) && (i + operationCode) < workdaysMTU.length){
  //           if (workdaysMTU[i] > nowSec) {
  //             nextBus = workdaysMTU[i + operationCode];
  //             intervalTime = i + operationCode > 0 ? workdaysMTU[i + operationCode] - workdaysMTU[i + operationCode - 1] : workdaysMTU[i + operationCode];
  //             countDown = nextBus - nowSec;
  //             break;
  //           }
  //         }else{
  //           print("超出范围");
  //           operationCode = (i + operationCode) < 0 ? operationCode + 1 : workdaysMTU.length - 1;
  //         }
  //       }
  //     }
  //   } else {
  //     if (now.weekday == 6 || now.weekday == 7) {
  //       for (int i = 0; i < weekendsUTM.length; i++) {
  //         if (0 <= (i + operationCode) && (i + operationCode) < weekendsUTM.length){
  //           if (weekendsUTM[i] > nowSec) {
  //             nextBus = weekendsUTM[i];
  //             intervalTime = i + operationCode > 0 ? weekendsUTM[i] - weekendsUTM[i - 1] : weekendsUTM[i];
  //             countDown = nextBus - nowSec;
  //             break;
  //           }
  //         }else{
  //           operationCode = (i + operationCode) < 0 ? operationCode + 1 : weekendsUTM.length - 1;
  //         }
  //       }
  //     } else {
  //       for (int i = 0; i < workdaysUTM.length; i++) {
  //         if (0 <= (i + operationCode) && (i + operationCode) < workdaysUTM.length){
  //           if (workdaysUTM[i] > nowSec) {
  //             nextBus = workdaysUTM[i];
  //             intervalTime = i > 0 ? workdaysUTM[i] - workdaysUTM[i - 1] : workdaysUTM[i];
  //             countDown = nextBus - nowSec;
  //             break;
  //           }
  //         }else{
  //           operationCode = (i + operationCode) < 0 ? operationCode + 1 : workdaysUTM.length - 1;
  //         }
  //       }
  //     }
  //   }
  // }
  void updateData() {
    final now = DateTime.now();
    int nowSec = now.hour * 3600 + now.minute * 60 + now.second;
    int index = 0;

    List<int> busTimes; // 用于存储当前选择的公交时间表

    // 根据条件选择不同的时间表
    if (_selectedValue == 1) {
      if (now.weekday == 6 || now.weekday == 7) {
        busTimes = weekendsMTU;
      } else {
        busTimes = workdaysMTU;
      }
    } else {
      if (now.weekday == 6 || now.weekday == 7) {
        busTimes = weekendsUTM;
      } else {
        busTimes = workdaysUTM;
      }
    }

    // 遍历选择的公交时间表
    for (int i = 0; i < busTimes.length; i++) {
      if (busTimes[i] > nowSec){
        isNextBus = true;
        index = i;
        break;
      }else{
        isNextBus = false;
      }
    }
    if (operationCode + index >= 0 && operationCode + index < busTimes.length){
      nextBus = busTimes[index + operationCode];
      intervalTime = index + operationCode > 0 ? busTimes[index + operationCode] - busTimes[index + operationCode - 1] : weekendsMTU[index + operationCode];
      countDown = busTimes[index + operationCode] - nowSec;
    }else if(operationCode + index < 0){
      operationCode = operationCode + 1;
    }else if(operationCode + index >= busTimes.length){
      operationCode = operationCode - 1;
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

  String countdownToStr(int sec) {
    bool isNegative = false;
    sec < 0 ? isNegative = true : isNegative = false;

    //debug
    // print("RAW: $sec isNegative: $isNegative");

    sec = isNegative == true ? sec * -1 : sec * 1;
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;
    int seconds = sec % 60;

    //debug
    // print("data: $sec hour:$hours min:$minutes sec:$seconds");

    String hoursStr = hours > 9 ? '$hours' : '0$hours';
    String minutesStr = minutes > 9 ? '$minutes' : '0$minutes';
    String secondsStr = seconds > 9 ? '$seconds' : '0$seconds';

    String result = "";
    result = isNegative == true
        ? "-$hoursStr:$minutesStr:$secondsStr"
        : "$hoursStr:$minutesStr:$secondsStr";
    return result;
  }

  Future<void> loadJSON() async {
    // 发起HTTP GET请求
    final response = await http.get(Uri.parse("https://wuyungang.net/Bus_Schedule.json"));

    if (response.statusCode == 200) {
      // 成功获取到数据，解码JSON
      setState(() {
        jsonString = response.body;  // 原始JSON字符串
      });
    } else {
      // 请求失败，处理错误
      throw Exception("Failed to load JSON");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> locations = <Widget>[
      Text(S.of(context).location1, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
      Text(S.of(context).location2, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400))
    ];
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
                    style: Theme.of(context).textTheme.headlineSmall),
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
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(const Color.fromRGBO(102, 187, 106, 1)),
                  ),
                  child: Text(S.of(context).specialthanks),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolBusTablePage(
                      workdaysMTU: workdaysMTU,
                      weekendsMTU: weekendsMTU,
                      workdaysUTM: workdaysUTM,
                      weekendsUTM: weekendsUTM,
                    )),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(const Color.fromRGBO(102, 187, 106, 1)),
                    alignment: Alignment.center
                  ),
                  child: Text(S.of(context).schoolBusTimeTable),
                )
              ]
          ),
        ),
        body:
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: (MediaQuery.of(context).size.width) * 0.95,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  elevation: 15.0,
                  child: Column(
                    children: [
                      Text(
                        "🚌${S.of(context).nextBusTime}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        nextBusStr,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "⏳${S.of(context).timeRemaining}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Visibility(
                          visible: isNextBus,
                          child: Text(
                            countDownStr,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                      ),
                      Visibility(
                        visible: isNextBus == false ? true : false,
                        child:
                          Center(
                            child: Text(
                              S.of(context).noMoreBus,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child:
                        Visibility(
                          visible: operationCode == 0 ? true : false,
                          child: FAProgressBar(
                            maxValue: 100,
                            changeColorValue: 25,
                            changeProgressColor: Colors.green,
                            currentValue: (countDown / intervalTime * 100).toDouble(),
                            displayText: '%',
                          ),
                        )
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "📍${S.of(context).locationSelection}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      SizedBox(
                        child:
                            Column(
                              children: [
                                ToggleButtons(
                                  onPressed: (int index){
                                    setState(() {
                                      for(int i = 0; i < _selectedLocation.length; i++){
                                        _selectedLocation[i] = i == index;
                                      }
                                      _selectedLocation[0] == true ? _selectedValue = 1 : _selectedValue = 2;
                                    });
                                  },
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  isSelected: _selectedLocation,
                                  selectedBorderColor: Colors.white,
                                  selectedColor: Colors.white,
                                  fillColor: Colors.green[400],
                                  color: Colors.green[600],
                                  constraints: BoxConstraints(
                                    minHeight: 40,
                                    minWidth: (MediaQuery.of(context).size.width) * 0.425,
                                  ),
                                  children: locations,
                                ),
                              ],
                            )
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {setState(() {operationCode = operationCode - 1;});},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: const Color.fromRGBO(102, 187, 106, 1),
                                  foregroundColor: Colors.white,
                                  fixedSize: Size(MediaQuery.of(context).size.width * 0.27, MediaQuery.of(context).size.height * 0.03)
                                ),
                                child: Text(
                                  S.of(context).pre,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                              ElevatedButton(
                                  onPressed: () {setState(() {operationCode = 0;});},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: const Color.fromRGBO(102, 187, 106, 1),
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(MediaQuery.of(context).size.width * 0.29, MediaQuery.of(context).size.height * 0.03)
                                  ),
                                  child: Text(
                                    S.of(context).now,
                                  ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                              ElevatedButton(
                                  onPressed: () {setState(() {operationCode = operationCode + 1;});},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: const Color.fromRGBO(102, 187, 106, 1),
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(MediaQuery.of(context).size.width * 0.27, MediaQuery.of(context).size.height * 0.03)
                                  ),
                                  child: Text(
                                    S.of(context).next,
                                  ),
                              ),
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.95),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  elevation: 15.0,
                  child: Column(
                    children: [
                      Text(
                        "⚠️${S.of(context).jock}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
