# gt4_flutter_plugin

The official flutter plugin project for GeeTest BehaviorVerification
. Support Flutter 2.0.
行为验 Flutter 官方插件。支持 Flutter 2.0。

[官网/Official](https://www.geetest.com)

## 开始 / Get started

## 安装 / Install

在工程 `pubspec.yaml` 中 `dependencies` 块中添加下列配置

**Github 集成**

```
dependencies:
  gt4_flutter_plugin:
    git:
      url: https://github.com/GeeTeam/gt4_flutter_plugin.git
      ref: master
```

或

**pub 集成**

```
dependencies:
  gt4_flutter_plugin: 0.0.1
```

## 配置 / Configuration

请在 [官网/Official](https://www.geetest.com) 申请验证 ID（captchaId）和 Key，并部署配套的后端接口。详细介绍请查阅：

[部署说明](https://docs.geetest.com/gt4/start/)/[Deploy Introduction](https://docs.geetest.com/gt4/overview/start/)

## 示例 / Example

### Init

```dart
final Gt4FlutterPlugin captcha = Gt4FlutterPlugin("123456789012345678901234567890ab");
```

### Verify

```dart
captcha.verify();
```

### Close

```dart
captcha.close();
```

### addEventHandler

```dart
captcha.addEventHandler(onShow: (Map<String, dynamic> message) async {
    // TO-DO
    // 验证视图已展示
    debugPrint("Captcha did show");
}, onResult: (Map<String, dynamic> message) async {
    debugPrint("Captcha result: " + message.toString());

    String status = message["status"];
    if (status == "1") {
        // TODO
        // 发送 message["result"] 中的数据向服务端二次查询接口查询结果
        // 对结果进行二次校验
        Map result = message["result"] as Map;

    } else {
        // 终端用户完成验证错误，自动重试
        debugPrint("Captcha 'onResult' state: $status");
    }
}, onError: (Map<String, dynamic> message) async {
    debugPrint("Captcha onError: " + message.toString());
    String code = message["code"];
    // TODO 处理验证中返回的错误
    if (Platform.isAndroid) {
        // Android 平台
        if (code == "-14460") {
        // 验证会话已取消
        } else {
        // 更多错误码参考开发文档
        // https://docs.geetest.com/gt4/apirefer/errorcode/android
        }
    }

    if (Platform.isIOS) {
        // iOS 平台
        if (code == "-20201") {
        // 验证请求超时
        }
        else if (code == "-20200") {
        // 验证会话已取消
        }
        else {
        // 更多错误码参考开发文档
        // https://docs.geetest.com/gt4/apirefer/errorcode/ios
        }
    }
});
```
