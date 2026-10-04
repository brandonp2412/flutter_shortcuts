import 'dart:io';

import 'package:flutter_shortcuts_new/flutter_shortcuts_new.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('longLabel uses the same wire key on Dart and Android', () {
    const shortcut = ShortcutItem(
      id: '1',
      action: 'open',
      shortLabel: 'Short',
      longLabel: 'Long label',
    );

    expect(shortcut.serialize()['longLabel'], 'Long label');
    expect(shortcut.serialize(), isNot(contains('LongLabel')));

    final nativeSource = File(
      'android/src/main/java/im/fluffychat/flutter_shortcuts_new/'
      'MethodCallImplementation.java',
    ).readAsStringSync();

    expect(
      RegExp(r'(?:info|shortcut)\.get\("longLabel"\)')
          .allMatches(nativeSource)
          .length,
      2,
    );
    expect(nativeSource, isNot(contains('get("LongLabel")')));
  });
}
