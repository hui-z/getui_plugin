# getui

这是一个用于集成个推的插件

## 使用

### 初始化

在`android/app/build.gradle`文件中的`android.defaultConfig`下添加`manifestPlaceholders`，配置个推相关的应用参数[个推Android集成](http://docs.getui.com/getui/mobile/android/androidstudio_maven/)

启动SDK

```dart
Getui.register(appID: '', appKey: '', appSecret: '');
```

### 获取cid

```dart
Getui.clientID()
```

### 监听透传消息

```dart
Getui.singleton().receivedMessageData.listen((onData){
    //处理透传消息
});
```

### 设置角标，别名与标签

```dart
Getui.setBadge(value: 0);
Getui.setTags(['value']);
Getui.bindAlias('alias', 'aSn');
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
