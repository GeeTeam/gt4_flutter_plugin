import 'dart:ui';

import 'gt4_enum.dart';

class GT4SessionConfiguration {
  /*
  静态资源文件的路径, 默认为空。
  如果为远程文件，则应为完成路径。
  如果为本地文件，则应为文件所在路径（不包含文件）。
   */
  String? resourcePath;

  // 远程访问静态资源时的协议，默认 @“https”。
  String? protocol;

  // 界面样式，3个枚举值，默认 `light`
  GTC4UserInterfaceStyle? userInterfaceStyle;

  // 背景颜色，默认透明
  Color? backgroundColor;

  // 调试模式开关，默认关闭
  bool? debugEnable;

  // 日志开关, 仅对 Android 生效
  bool? logEnable;

  // 点击背景的交互，默认开启。
  bool? canceledOnTouchOutside;

  // 单位为毫秒，ios 默认 8000，安卓 10000
  int? timeout;

  /*
  语言，默认跟随系统。
  如果系统为不支持的语言，则为中文简体。
  指定语言请参考文档中的语言短码清单（ISO 639-2 标准）
  */
  String? language;

  // Static service address, empty by default
  List<String>? staticServers;

  // Interface service address, default is empty
  List<String>? apiServers;

  // 额外的参数, 默认为空。参数将被组装后提交到验证服务。
  Map<String, dynamic>? additionalParameter;

  Map<String, dynamic> toMap() {
    return {
      "resourcePath": resourcePath,
      "protocol": protocol,
      "userInterfaceStyle": userInterfaceStyle?.index,
      "backgroundColor": backgroundColor?.value.toRadixString(16),
      "debugEnable": debugEnable,
      "logEnable": logEnable,
      "canceledOnTouchOutside": canceledOnTouchOutside,
      "timeout": timeout,
      "language": language,
      "additionalParameter": additionalParameter,
      "staticServers": staticServers,
      "apiServers": apiServers
    }..removeWhere((key, value) => value == null);
  }
}
