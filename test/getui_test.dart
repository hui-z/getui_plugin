import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getui/getui.dart';

void main() {
  const MethodChannel channel = MethodChannel('getui');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
