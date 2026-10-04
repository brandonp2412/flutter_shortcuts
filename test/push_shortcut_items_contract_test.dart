import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pushShortcutItems uses push semantics for every shortcut', () {
    final nativeSource = File(
      'android/src/main/java/im/fluffychat/flutter_shortcuts_new/'
      'MethodCallImplementation.java',
    ).readAsStringSync();

    final methodStart =
        nativeSource.indexOf('private void pushShortcutItems(MethodCall call)');
    final methodEnd = nativeSource.indexOf(
      'private void updateShortcutItems(MethodCall call)',
      methodStart,
    );

    expect(methodStart, greaterThanOrEqualTo(0));
    expect(methodEnd, greaterThan(methodStart));

    final methodSource = nativeSource.substring(methodStart, methodEnd);
    expect(methodSource, contains('ShortcutManagerCompat.pushDynamicShortcut'));
    expect(methodSource,
        isNot(contains('ShortcutManagerCompat.addDynamicShortcuts')));
  });
}
