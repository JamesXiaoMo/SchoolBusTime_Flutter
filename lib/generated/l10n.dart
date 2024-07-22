// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `School Bus Time`
  String get title {
    return Intl.message(
      'School Bus Time',
      name: 'title',
      desc: 'The title of the application',
      args: [],
    );
  }

  /// `Next school bus departure time: `
  String get nextBusTime {
    return Intl.message(
      'Next school bus departure time: ',
      name: 'nextBusTime',
      desc: 'Label for the next bus departure time',
      args: [],
    );
  }

  /// `Time remaining: `
  String get timeRemaining {
    return Intl.message(
      'Time remaining: ',
      name: 'timeRemaining',
      desc: 'Label for the remaining time until the next bus',
      args: [],
    );
  }

  /// `Choose your language`
  String get chooseLanguage {
    return Intl.message(
      'Choose your language',
      name: 'chooseLanguage',
      desc: 'Label for the language selection option',
      args: [],
    );
  }

  /// `School Bus Time`
  String get appName {
    return Intl.message(
      'School Bus Time',
      name: 'appName',
      desc: 'The name of the application',
      args: [],
    );
  }

  /// `Version: alpha 0.0.1`
  String get version {
    return Intl.message(
      'Version: alpha 0.0.1',
      name: 'version',
      desc: 'The version of the application',
      args: [],
    );
  }

  /// `Designed by Jameswu in Fukuyama`
  String get designedBy {
    return Intl.message(
      'Designed by Jameswu in Fukuyama',
      name: 'designedBy',
      desc: 'Design credit for the application',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: 'Label for selecting the English language',
      args: [],
    );
  }

  /// `Chinese`
  String get chinese {
    return Intl.message(
      'Chinese',
      name: 'chinese',
      desc: 'Label for selecting the Chinese language',
      args: [],
    );
  }

  /// `Japanese`
  String get japanese {
    return Intl.message(
      'Japanese',
      name: 'japanese',
      desc: 'Label for selecting the Japanese language',
      args: [],
    );
  }

  /// `Where would you like to ride the school bus from?`
  String get locationSelection {
    return Intl.message(
      'Where would you like to ride the school bus from?',
      name: 'locationSelection',
      desc: '',
      args: [],
    );
  }

  /// `Matsunaga`
  String get location1 {
    return Intl.message(
      'Matsunaga',
      name: 'location1',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get location2 {
    return Intl.message(
      'University',
      name: 'location2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
