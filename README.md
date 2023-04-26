[English version](./README_EN.md)


# gt4_flutter_plugin

行为验 Flutter 官方插件。支持 Flutter 2.x/3.x。

[官网](https://www.geetest.com/)

## 安装

在工程 `pubspec.yaml` 中 `dependencies` 块中添加下列配置

**如果使用** **Github 集成**

```yaml
dependencies:
  gt4_flutter_plugin:
    git:
      url: https://github.com/GeeTeam/gt4_flutter_plugin.git
      ref: master
```

**如果使用** **pub 集成**

```yaml
dependencies:
  gt4_flutter_plugin: ^0.0.6
```

# 导入 SDK

**注意：请将 SDK 导入到极验行为验 Flutter 插件的对应目录下，而非您项目的目录下**

因为行为验原生 SDK 未提供远程依赖方式获取，需要手动下载和配置。在安装完 Flutter 插件后，需要手动从官网下载 [Android](https://docs.geetest.com/gt4/deploy/client/android#%E6%89%8B%E5%8A%A8%E4%B8%8B%E8%BD%BD%E9%9B%86%E6%88%90) 和 [iOS](https://docs.geetest.com/gt4/deploy/client/ios#%E8%8E%B7%E5%8F%96SDK) 的原生 SDK，并手动导入到相应的本地依赖路径：

```bash
/** Android Flutter 插件(Android Flutter plugin path) */
android/libs/*

/** iOS Flutter 插件(iOS Flutter plugin path) */
ios/Librarie/*
```

**注：使用`flutter pub get`下载插件成功后，Project>External Libraries>Flutter Plugins 中可以找到极验行为验 Flutter 插件的对应路径，上述插件路径即为此处。**

iOS 在插件对应路径导入SDK后，还需要在 Xcode 原生项目中导入资源文件`GTCaptcha4.bundle`, 否则集成后会报资源找不到的错误

Android 在插件对应路径导入SDK后，还需要在插件的 `android/build.gradle` 文件中 `dependencies` 标签内添加 `api(name:'geetest_captcha_android_vx.y.z_date', ext:'aar')`

## 配置

请在 [官网](https://www.geetest.com/) 申请验证 ID（captchaId）和 Key，并部署配套的后端接口。详细介绍请查阅：[部署说明](https://docs.geetest.com/gt4/start/)

## 示例

### Init

> 集成前，请先替换从后台申请的 captchaId
>

```dart
var config = GT4SessionConfiguration();
    config.language = "en";
    config.debugEnable = true;
    config.backgroundColor = Colors.orange;
    captcha =
        Gt4FlutterPlugin("123456789012345678901234567890ab",config);
```

config 说明

| 属性 | 属性类型 | 属性说明 |
| --- | --- | --- |
| resourcePath | String | 静态资源文件的路径, 默认加载本地文件路径无特殊需求，无需配置可配置远程文件，应设置完整路径 |
| protocol | String | 远程访问静态资源时的协议，默认 "https" |
| userInterfaceStyle | GTC4UserInterfaceStyle | 界面样式, 枚举值<br>`system` 跟随系统样式<br>`light`普通样式<br>`dark` 暗黑样式<br>iOS 默认 `light`，Android 默认`system` |
| backgroundColor | Color | 背景颜色，默认透明 |
| debugEnable | bool | 调试模式开关，默认关闭 |
| canceledOnTouchOutside | bool | 点击背景的交互，默认开启 |
| timeout | int | 请求超时时长，单位为毫秒，iOS 默认8000，Android 默认 10000 |
| language | String | 语言。默认跟随系统，如果当前系统语言为插件不支持的语言，则为中文简体指定语言请参考文档中的语言短码清单（ISO 639-2 标准） |
| additionalParameter | Map<String,dynamic> | 额外的配置参数，默认为空。参数将被组装后提交到服务端。 |

### Verify

`captcha.verify();`

### Close

`captcha.close();`

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
        // 终端用户完成验证错误，验证会自动刷新
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

