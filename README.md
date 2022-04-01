# gt4_flutter_plugin

The official flutter plugin project for GeeTest BehaviorVerification
. Support Flutter 2.0.
行为验 Flutter 官方插件。支持 Flutter 2.0。

[官网/Official](https://www.geetest.com)

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
  gt4_flutter_plugin: 0.0.2
```

# 导入 SDK / Import SDK

因为行为验原生 SDK 未提供远程依赖方式获取，需要手动下载和配置。在安装完 Flutter 插件后，需要手动从官网下载 [Android](https://docs.geetest.com/gt4/deploy/client/android#%E6%89%8B%E5%8A%A8%E4%B8%8B%E8%BD%BD%E9%9B%86%E6%88%90) 和 [iOS](https://docs.geetest.com/gt4/deploy/client/ios#%E8%8E%B7%E5%8F%96SDK) 的原生 SDK，并手动导入到相应的本地依赖路径：

> Since GeeTest didn't provide the remote dependency integration for native SDKs of GeeTest, we had to import native SDKs manually. After install flutter plugin, we should download [Android](https://docs.geetest.com/BehaviorVerification/deploy/client/android#Installation) and [iOS](https://docs.geetest.com/BehaviorVerification/deploy/client/ios#Get-SDK) native SDK from office website. And then, import it to follow paths or project manually:

```
/** Android 主程序的 libs 路径(Android main project libs path) */
example/android/app/libs

/** iOS Flutter 插件(iOS Flutter plugin path) */
ios/Libraries/*
```

## 配置 / Configuration

请在 [官网/Official](https://www.geetest.com) 申请验证 ID（captchaId）和 Key，并部署配套的后端接口。详细介绍请查阅：

[部署说明](https://docs.geetest.com/gt4/start/)/[Deploy Introduction](https://docs.geetest.com/gt4/overview/start/)

## 示例 / Example

### Init

> 集成前，请先替换从后台申请的 `captchaId`（Before initial new instance, replace `captchaId` sample with one of the captchaId registered from account backend.）

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
