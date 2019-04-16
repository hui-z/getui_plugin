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

  /// iOS 设置角标
  static Future setBadge({int value = 0}) async {
    return await _channel.invokeMethod("setBadge", value);
  }

  /// 设置标签
  static Future setTags(List<String> value) async {
    return await _channel.invokeMethod("setTags", value);
  }

  /// 绑定用户别名
  static Future bindAlias(String alias, String aSn) async {
    return await _channel.invokeMethod("bindAlias", [alias, aSn]);
  }

  /// 解绑用户名
  static Future unbindAlias(String alias, String aSn, bool isSelf) async {
    return await _channel.invokeMethod("unbindAlias", [alias, aSn, isSelf]);
  }

  ///  SDK登入成功返回clientId
  Stream<String> get receivedClientID => _receivedClientIDController.stream;

  /// SDK接收个推推送的透传消息
  Stream<ReceivedPushMessage> get receivedMessageData =>
      _receivedMessageDataController.stream;

  final StreamController<String> _receivedClientIDController =
      StreamController.broadcast();

  final StreamController<ReceivedPushMessage> _receivedMessageDataController =
      StreamController.broadcast();

  Future<dynamic> _handler(MethodCall methodCall) {
    switch (methodCall.method) {
      case 'onReceiveMessageData':
        _receivedMessageDataController
            .add(ReceivedPushMessage.fromMap(methodCall.arguments));
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
  final String payload;
  final bool offLine; // only for ios platform

  ReceivedPushMessage.fromMap(Map<dynamic, dynamic> map)
      : assert(map != null),
        appId = map['appId'],
        messageId = map['messageId'],
        taskId = map['taskId'],
        payload = map['payload'],
        offLine = map['offLine'];

  @override
  String toString() {
    return 'ReceivedPushMessage{appId: $appId, messageId: $messageId, taskId: $taskId, payload: $payload, offLine: $offLine}';
  }
}
