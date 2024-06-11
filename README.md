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
  gt4_flutter_plugin: ^0.1.1
```

## 导入SDK

**注意：插件从 0.0.8 版本开始无需手动导入SDK，但 iOS 因资源引用问题，仍需手动将 `GTCaptcha4.bundle` 拖入 Xcode**

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
    captcha = Gt4FlutterPlugin("123456789012345678901234567890ab",config);
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
| apiServers |   List<String> |  控制api请求的地址 |
| staticServers |   List<String> | 控制静态资源请求的地址 |
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

