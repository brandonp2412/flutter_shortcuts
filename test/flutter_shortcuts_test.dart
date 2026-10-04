import 'dart:async';

import 'package:flutter_shortcuts_new/flutter_shortcuts_new.dart';
import 'package:flutter_shortcuts_new/src/platform/flutter_shortcuts_platform.dart';
import 'package:flutter_test/flutter_test.dart';

class _DelayedPlatform extends FlutterShortcutsPlatform {
  final initializeCompleter = Completer<void>();
  final listenCompleter = Completer<void>();

  @override
  Future<void> initialize(bool debug) => initializeCompleter.future;

  @override
  Future<void> listenAction(ShortcutAction action) => listenCompleter.future;
}

void main() {
  late FlutterShortcutsPlatform originalPlatform;

  setUp(() {
    originalPlatform = FlutterShortcutsPlatform.instance;
  });

  tearDown(() {
    FlutterShortcutsPlatform.instance = originalPlatform;
  });

  test('initialize waits for platform initialization', () async {
    final platform = _DelayedPlatform();
    FlutterShortcutsPlatform.instance = platform;

    var completed = false;
    final future = FlutterShortcuts()
        .initialize(debug: false)
        .whenComplete(() => completed = true);

    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    platform.initializeCompleter.complete();
    await future;
    expect(completed, isTrue);
  });

  test('listenAction waits for listener registration', () async {
    final platform = _DelayedPlatform();
    FlutterShortcutsPlatform.instance = platform;

    var completed = false;
    final future = FlutterShortcuts()
        .listenAction((_) {})
        .whenComplete(() => completed = true);

    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    platform.listenCompleter.complete();
    await future;
    expect(completed, isTrue);
  });
}
