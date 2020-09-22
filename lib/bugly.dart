
import 'dart:async';

import 'package:flutter/services.dart';

class Bugly {
  static const MethodChannel _channel =
      const MethodChannel('bugly');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


  static void setUp(appID) {
    //使用app_id进行SDK注册
    _channel.invokeMethod("setUp",{'app_id':appID});
  }
  static void postException(error, stack) {
    //将异常和堆栈上报至Bugly
    _channel.invokeMethod("postException",{'crash_message':error.toString(),'crash_detail':stack.toString()});
  }
}
