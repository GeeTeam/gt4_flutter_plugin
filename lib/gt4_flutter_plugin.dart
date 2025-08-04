import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gt4_flutter_plugin/gt4_session_configuration.dart';

typedef EventHandler = Function(Map<String, dynamic> event);

class Gt4FlutterPlugin {
  static const String flutterLog = "| Geetest 4.0 | Flutter | ";
  static const MethodChannel _channel = MethodChannel('gt4_flutter_plugin');

  static String get version {
    return "0.1.2";
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EventHandler? _onShow;
  EventHandler? _onResult;
  EventHandler? _onError;

  Gt4FlutterPlugin(String captchaId, [GT4SessionConfiguration? config]) {
    try {
      _channel.invokeMethod(
          'initWithCaptcha',
          {'captchaId': captchaId, 'config': config?.toMap()}
            ..removeWhere((key, value) => value == null));
    } catch (e) {
      debugPrint(flutterLog + e.toString());
    }
  }

  /// 开启验证
  void verify() {
    try {
      _channel.invokeMethod('verify');
    } catch (e) {
      debugPrint(flutterLog + e.toString());
    }
  }

  // 关闭验证
  void close() {
    try {
      _channel.invokeMethod('close');
    } catch (e) {
      debugPrint(flutterLog + e.toString());
    }
  }

  void configurationChanged(Object object) {
    try {
      _channel.invokeMethod('configurationChanged', {'newConfig': object});
    } catch (e) {
      debugPrint(flutterLog + e.toString());
    }
  }

  ///
  /// 注册事件回调
  ///
  void addEventHandler({
    /// 验证完成，可能成功或者错误
    /// 成功结构示例:
    /// {result: {"lot_number":"5df5c616d4aa49aa82d44aceb6c76264",
    /// "pass_token":"282282c00077c1cc11d8b4b29e361fcfb3421916220ed9bf253803711b98f1ef",
    /// "gen_time":"1636015810","captcha_output":"1X_RK3ag_IKlW15iHhSywQ=="}, status: "1"}
    /// 失败结构示例:
    /// {result: {"captchaId":"647f5ed2ed8acb4be36784e01556bb71","captchaType":"slide",
    /// "challenge":"d04423f3-5297-44f5-bafa-cb868095c605"}, status: "0"}
    EventHandler? onResult,

    /// 错误回调
    /// 结构示例：{msg: 验证会话已取消, code: -14460, desc: {"description":"User cancelled 'Captcha'"}}
    /// 需要根据端类型区别处理错误码
    /// Android: https://docs.geetest.com/gt4/apirefer/errorcode/android
    /// iOS: https://docs.geetest.com/gt4/apirefer/errorcode/ios
    EventHandler? onError,

    ///
    ///
    ///
    EventHandler? onShow,
  }) {
    debugPrint("${flutterLog}addEventHandler");

    _onShow = onShow;
    _onResult = onResult;
    _onError = onError;
    _channel.setMethodCallHandler(_handler);
  }

  /// 原生回调
  Future<dynamic> _handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "onShow":
        debugPrint("${flutterLog}onShow:$_onShow");
        return _onShow!(methodCall.arguments.cast<String, dynamic>());
      case "onResult":
        debugPrint("${flutterLog}onResult:$_onResult");
        return _onResult!(methodCall.arguments.cast<String, dynamic>());
      case "onError":
        debugPrint("${flutterLog}onError:$_onError");
        return _onError!(methodCall.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError("${flutterLog}Unrecognized Event");
    }
  }
}
