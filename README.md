# gt4_flutter_plugin

The official flutter plugin project for GeeTest Adaptive CAPTCHA. Support Flutter 2.0.
行为验 Flutter 官方插件。支持 Flutter 2.0。

[官网/Official](https://www.geetest.com)

## 安装 / Install

在工程 `pubspec.yaml` 中 `dependencies` 块中添加下列配置<br>
Follow the steps below to set up dependencies in project pubspec.yaml

**Github 集成** / **Github integration**

```
dependencies:
  gt4_flutter_plugin:
    git:
      url: https://github.com/GeeTeam/gt4_flutter_plugin.git
      ref: master
```

或 / or

**pub 集成** / pub integration

```
dependencies:
  gt4_flutter_plugin: 0.0.3
```

# 导入 SDK / Import SDK

因为行为验原生 SDK 未提供远程依赖方式获取，需要手动下载和配置。在安装完 Flutter 插件后，需要手动从官网下载 [Android](https://docs.geetest.com/gt4/deploy/client/android#%E6%89%8B%E5%8A%A8%E4%B8%8B%E8%BD%BD%E9%9B%86%E6%88%90) 和 [iOS](https://docs.geetest.com/gt4/deploy/client/ios#%E8%8E%B7%E5%8F%96SDK) 的原生 SDK，并手动导入到相应的本地依赖路径：

> Since GeeTest didn't provide the remote dependency integration for native SDKs currently, it means you need to download and configure it manually. After installing the flutter plugin, please  download the native [Android](https://docs.geetest.com/BehaviorVerification/deploy/client/android#Installation) and [iOS](https://docs.geetest.com/BehaviorVerification/deploy/client/ios#Get-SDK) SDK from from [GeeTest dashboard](https://auth.geetest.com/login). And then,  import it to following paths:

```
/** Android Flutter 插件(Android Flutter plugin path) */
android/libs

/** iOS Flutter 插件(iOS Flutter plugin path) */
ios/Libraries
```
**注：使用`pub get`下载插件成功后，Project>External Libraries>Flutter Plugins 中可以找到本插件，上述插件路径即为此处。**
> Note: The plug-in can be found in `Project>External Libraries>Flutter Plugins` after successful download using `pub get` command. The plugin path above is here.

iOS 在插件对应路径导入SDK后，还需要在 Xcode 原生项目中导入资源文件`GTCaptcha4.bundle`, 否则集成后会报资源找不到的错误
> iOS needs to import the resource file `GTCaptcha4.bundle` in the Xcode native project after importing the SDK into the corresponding path of the plugin, otherwise it will report an error that the resource cannot be found after integration


## 配置 / Configuration

请在 [官网](https://www.geetest.com) 申请验证 ID（captchaId）和 Key，并部署配套的后端接口。详细介绍请查阅：[部署说明](https://docs.geetest.com/gt4/start/)

Create your IDs and keys (GeeTest CAPTCHA V4) on [GeeTest dashboard](https://auth.geetest.com/login), and deploy the corresponding back-end API based on [GeeTest documents](https://docs.geetest.com/BehaviorVerification/overview/start/). 

## 示例 / Example

### Init

> 集成前，请先替换从后台申请的 `captchaId`（Please replace random captchaID in the below example with captchaID that you created from [GeeTest dashboard](https://auth.geetest.com/product/) before you process the integration. ）

```dart
var config = GT4SessionConfiguration();
    config.language = "en";
    config.debugEnable = true;
    config.backgroundColor = Colors.orange;
    captcha =
        Gt4FlutterPlugin("123456789012345678901234567890ab",config);
```

config 说明 / config explanation

属性/attribute|属性类型/attribute types|属性说明/attribute explanation
-----|-----|------
resourcePath | String | 静态资源文件的路径, 默认加载本地文件路径<br>无特殊需求，无需配置<br>可配置远程文件，应设置完整路径 <br> Static resource file path is the load local file path by default. If ther is no special requirements, you don't need to configure it. You should set the full path for configurable remote files.
protocol | String | 远程访问静态资源时的协议，默认 `https`<br>It is used for remote access to static resources. The default value is `https`
userInterfaceStyle | GTC4UserInterfaceStyle | 界面样式,枚举 / Interface style, enumeration<br>`system` 跟随系统样式 / system style <br>`light`普通样式 / normal style <br>`dark`暗黑样式 / dark style <br> iOS 默认 `light`，Android默认`system` <br>iOS default interface is `light`, Android default interface is `system`
backgroundColor| Color | 背景颜色，默认透明 <br> it is used for set background color, the default value is transparency.
debugEnable | bool | 调试模式开关，默认关闭 <br> Debugging mode switch, the default value is turn off
canceledOnTouchOutside | bool | 点击背景的交互，默认开启 <br> It is used for interaction of background clicking, the default value is on.
timeout | int | 请求超时时长，单位为毫秒，iOS 默认`8000 `，Android `10000`<br> Request timeout duration. The unit is milliseconds. The default value is `8000` for iOS and `10000` for Android
language | String | 语言，默认跟随系统<br> 如果系统为不支持的语言，则为中文简体<br>指定语言请参考文档中的语言短码清单（ISO 639-2 标准）<br>It is used for language setting, the default value is the same as system language. <br>The default language will be Chinese if your system language is not included in GeeTest multilingual setting. <br>Refer to the list of language short codes in the documentation (ISO 639-2) to specify the language.
additionalParameter | Map<String,dynamic> | 额外的参数, 默认为空。参数将被组装后提交到验证服务 <br> Additional parameters, null by default. The parameters will be assembled and submitted to the verification service.

  
  


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
    // 验证视图已展示 the captcha view is displayed
    debugPrint("Captcha did show");
}, onResult: (Map<String, dynamic> message) async {
    debugPrint("Captcha result: " + message.toString());

    String status = message["status"];
    if (status == "1") {
        // TODO
        // 发送 message["result"] 中的数据向服务端二次查询接口查询结果 Send the data in the message ["result"] to query your API
        // 对结果进行二次校验 validate the result
        Map result = message["result"] as Map;

    } else {
        // 终端用户完成验证错误，自动重试 If the verification fails, it will be automatically retried.
        debugPrint("Captcha 'onResult' state: $status");
    }
}, onError: (Map<String, dynamic> message) async {
    debugPrint("Captcha onError: " + message.toString());
    String code = message["code"];
    // TODO 处理验证中返回的错误 Handling errors returned in verification
    if (Platform.isAndroid) {
        // Android 平台
        if (code == "-14460") {
        // 验证会话已取消 The authentication session has been canceled
        } else {
        // 更多错误码参考开发文档 More error codes refer to the development document
        // https://docs.geetest.com/gt4/apirefer/errorcode/android
        }
    }

    if (Platform.isIOS) {
        // iOS 平台
        if (code == "-20201") {
        // 验证请求超时 Verify request timeout
        }
        else if (code == "-20200") {
        // 验证会话已取消 The authentication session has been canceled
        }
        else {
        // 更多错误码参考开发文档 More error codes refer to the development document
        // https://docs.geetest.com/gt4/apirefer/errorcode/ios
        }
    }
});
```
