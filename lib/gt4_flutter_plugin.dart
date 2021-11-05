import 'dart:async';

import 'package:flutter/services.dart';

typedef EventHandler = Function(Map<String, dynamic> event);

class Gt4FlutterPlugin {
  static const String flutterLog = "| Geetest | Flutter | ";
  static const MethodChannel _channel = MethodChannel('gt4_flutter_plugin');

  static String get version {
    return "0.0.1";
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EventHandler? _onSuccess;
  EventHandler? _onFailure;

  /// 使用注册参数开启验证
  void verifyWithCaptcha(String captchaId) {
    try {
      _channel.invokeMethod('verifyWithCaptcha', {'captchaId': captchaId});
    } catch (e) {
      print(flutterLog + e.toString());
    }
  }

  void configurationChanged(Object object){
    try {
      _channel.invokeMethod('configurationChanged', {'newConfig': object});
    } catch (e) {
      print(flutterLog + e.toString());
    }
  }

  ///
  /// 注册事件回调
  ///
  void addEventHandler({
    /// 验证完成，可能成功或者错误
    /// 成功结构示例:
    /// {response: {"lot_number":"5df5c616d4aa49aa82d44aceb6c76264",
    /// "pass_token":"282282c00077c1cc11d8b4b29e361fcfb3421916220ed9bf253803711b98f1ef",
    /// "gen_time":"1636015810","captcha_output":"1X_RK3ag_IKlW15iHhSywQ=="}, state: true}
    /// 失败结构示例:
    /// {response: {"captchaId":"647f5ed2ed8acb4be36784e01556bb71","captchaType":"slide",
    /// "challenge":"d04423f3-5297-44f5-bafa-cb868095c605"}, state: false}
    EventHandler? onSuccess,

    /// 错误回调
    /// 结构示例：{msg: 验证会话已取消, code: -14460, desc: {"description":"User cancelled 'Captcha'"}}
    /// 需要根据端类型区别处理错误码
    /// Android: https://docs.geetest.com/gt4/apirefer/errorcode/android
    /// iOS: https://docs.geetest.com/gt4/apirefer/errorcode/ios
    EventHandler? onFailure,
  }) {
    print(flutterLog + "addEventHandler");

    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _channel.setMethodCallHandler(_handler);
  }

  /// 原生回调
  Future<dynamic> _handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "onSuccess":
        print(flutterLog + "onSuccess:" + _onSuccess.toString());
        return _onSuccess!(methodCall.arguments.cast<String, dynamic>());
      case "onFailure":
        print(flutterLog + "onFailure:" + _onFailure.toString());
        return _onFailure!(methodCall.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError(flutterLog + "Unrecognized Event");
    }
  }
}
