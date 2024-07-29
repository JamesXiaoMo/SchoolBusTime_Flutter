// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("スクールバスタイム"),
        "chinese": MessageLookupByLibrary.simpleMessage("中国語"),
        "chooseLanguage": MessageLookupByLibrary.simpleMessage("言語を選択"),
        "designedBy": MessageLookupByLibrary.simpleMessage(
            "Designed by Jameswu in Fukuyama"),
        "english": MessageLookupByLibrary.simpleMessage("英語"),
        "japanese": MessageLookupByLibrary.simpleMessage("日本語"),
        "location1": MessageLookupByLibrary.simpleMessage("松永"),
        "location2": MessageLookupByLibrary.simpleMessage("福大"),
        "locationSelection":
            MessageLookupByLibrary.simpleMessage("どこからスクールバスに乗りたいですか？"),
        "nextBusTime": MessageLookupByLibrary.simpleMessage("次のスクールバスの出発時間: "),
        "timeRemaining": MessageLookupByLibrary.simpleMessage("残り時間: "),
        "title": MessageLookupByLibrary.simpleMessage("スクールバスタイム"),
        "version": MessageLookupByLibrary.simpleMessage("バージョン: alpha 0.0.2")
      };
}
