import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bugly/bugly.dart';



//上报数据至Bugly
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  Bugly.postException(error, stackTrace);
}

Future<Null> main() async {
  //注册Flutter框架的异常回调
  FlutterError.onError = (FlutterErrorDetails details) async {
    //转发至Zone的错误回调
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  //自定义错误提示页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
    return Scaffold(
        body: Center(
          child: Text("Custom Error Widget"),
        )
    );
  };
  //使用runZone方法将runApp的运行放置在Zone中，并提供统一的异常回调
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {

    //由于Bugly视iOS和Android为两个独立的应用，因此需要使用不同的App ID进行初始化
    if(Platform.isAndroid){
      Bugly.setUp('adf656d2d8');
    }else if(Platform.isIOS){
      Bugly.setUp('1ef97c9d68');
    }

    super.initState();

  }

  // Platform messages are asynchronous, so we initialize in an async method.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Crashy'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Dart exception'),
                onPressed: () {
                  //触发同步异常
                  throw StateError('This is a Dart exception.');
                },
              ),
              RaisedButton(
                child: Text('async Dart exception'),
                onPressed: () {
                  //触发异步异常
                  Future.delayed(Duration(seconds: 1))
                      .then((e) => throw StateError('This is a Dart exception in Future.'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
