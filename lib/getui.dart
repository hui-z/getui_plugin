import 'dart:async';

import 'package:flutter/services.dart';

class Getui {
  static final Getui _singleton = new Getui._internal();
  factory Getui.singleton() {
    return _singleton;
  }
  Getui._internal() {
    _channel.setMethodCallHandler(_handler);
  }

  static const MethodChannel _channel = const MethodChannel('getui');

  /// 获取clientID
  static Future<String> clientID() async {
    return await _channel.invokeMethod("clientID");
  }

  /// 初始化
  static Future register(
      {String appID, String appKey, String appSecret}) async {
    return await _channel.invokeMethod("register", [appID, appKey, appSecret]);
  }

  final StreamController<String> _receivedClientIDController =
      StreamController.broadcast();

  Stream<String> get receivedClientID => _receivedClientIDController.stream;

  final StreamController<ReceivedPushMessage> _receivedMessageDataController =
      StreamController.broadcast();

  Stream<ReceivedPushMessage> get receivedMessageData =>
      _receivedMessageDataController.stream;

  Future<dynamic> _handler(MethodCall methodCall) {
    switch (methodCall.method) {
      case 'onReceiveMessageData':
        _receivedMessageDataController.add(methodCall.arguments);
        break;
      case 'onReceiveClientId':
        _receivedClientIDController.add(methodCall.arguments);
        break;
      default:
    }
    return Future.value(true);
  }
}

class ReceivedPushMessage {
  final String appId;
  final String messageId;
  final String taskId;
  final String packageName; // only for android platform
  final String clientId; // only for android platform
  final String payload;
  final bool offLine; // only for ios platform

  ReceivedPushMessage.fromMap(Map<dynamic, dynamic> map)
      : assert(map != null),
        appId = map['appId'],
        messageId = map['messageId'],
        taskId = map['taskId'],
        packageName = map['packageName'],
        clientId = map['clientId'],
        payload = map['payload'],
        offLine = map['offLine'];

  @override
  String toString() {
    return 'ReceivedPushMessage{appId: $appId, messageId: $messageId, taskId: $taskId, packageName: $packageName, clientId: $clientId, payload: $payload, offLine: $offLine}';
  }
}
