Behavior verification Flutter official plugin. Supports Flutter 2.x/3.x.

[Official website/Official](https://www.geetest.com/)

## Installation

Add the following configuration to the `dependencies` block in the project's `pubspec.yaml`:

**If using** **Github integration**

```
dependencies:
  gt4_flutter_plugin:
    git:
      url: <https://github.com/GeeTeam/gt4_flutter_plugin.git>
      ref: master

```

**If using** **pub integration**

```
dependencies:
  gt4_flutter_plugin: ^0.0.6

```

# Import SDK

**Note: Please import the SDK into the corresponding directory of the Geetest behavior verification Flutter plugin, not to the root directory of your project.**

Because the behavior verification native SDK does not provide remote dependency acquisition, it needs to be downloaded and configured manually. After installing the Flutter plugin, you need to manually download the native SDK for [Android](https://docs.geetest.com/gt4/deploy/client/android#%E6%89%8B%E5%8A%A8%E4%B8%8B%E8%BD%BD%E9%9B%86%E6%88%90) and [iOS](https://docs.geetest.com/gt4/deploy/client/ios#%E8%8E%B7%E5%8F%96SDK), and manually import it into the corresponding local dependency path:

```
/** Android Flutter plugin(Android Flutter plugin path) */
android/libs/*

/** iOS Flutter plugin(iOS Flutter plugin path) */
ios/Librarie/*

```

**Note: After successfully downloading the plugin using `flutter pub get`, you can find the corresponding path of the Geetest behavior verification Flutter plugin in Project>External Libraries>Flutter Plugins. The above plugin path is for this.**

After importing the SDK into the corresponding path of the plugin for iOS, you also need to import the resource file `GTCaptcha4.bundle` in the Xcode native project, otherwise the integration will report a resource not found error.

After importing the SDK into the corresponding path of the plugin for Android, you also need to add `api(name:'geetest_captcha_android_vx.y.z_date', ext:'aar')` in the `dependencies` tag of the plugin's `android/build.gradle` file.

## Configuration

Please apply for the verification ID (captchaId) and key on the [official website](https://www.geetest.com/) and deploy the matching backend interface. For detailed instructions, please refer to: [Deployment Instructions](https://docs.geetest.com/gt4/start/)

## Example

### Init

> Before integration, please replace the captchaId obtained from the backend first.
>

```
var config = GT4SessionConfiguration();
    config.language = "en";
    config.debugEnable = true;
    config.backgroundColor = Colors.orange;
    captcha =
        Gt4FlutterPlugin("123456789012345678901234567890ab",config);

```

config explanation

| Attribute | Attribute type | Attribute explanation |
| --- | --- | --- |
| resourcePath | String | The path of the static resource file. If there is no special requirement for loading the local file path, no configuration is required. You can configure the remote file and should set the complete path. |
| protocol | String | The protocol used to access static resources remotely, default is "https". |
| userInterfaceStyle | GTC4UserInterfaceStyle | Interface style, enumeration value: system follows the system style, light is the normal style, and dark is the dark style. The default is light for iOS and system for Android. |
| backgroundColor | Color | Background color, default is transparent. |
| debugEnable | bool | Debug mode switch, default is off. |
| canceledOnTouchOutside | bool | Interaction when clicking on the background, default is on. |
| timeout | int | Request timeout duration, in milliseconds, default is 8000 for iOS and 10000 for Android. |
| language | String | Language. The default is to follow the system. If the current system language is not supported by the plugin, it will be simplified Chinese. For the language short code list (ISO 639-2 standard), please refer to the document for the specified language. |
| additionalParameter | Map<String,dynamic> | Additional configuration parameters, default is empty. The parameters will be assembled and submitted to the server. |

### Verify

`captcha.verify();`

### Close

`captcha.close();`

### addEventHandler

```
captcha.addEventHandler(onShow: (Map<String, dynamic> message) async {
    // TO-DO
    // the captcha view is displayed
    debugPrint("Captcha did show");
}, onResult: (Map<String, dynamic> message) async {
    debugPrint("Captcha result: " + message.toString());

    String status = message["status"];
    if (status == "1") {
        // TODO
        // Send the data in the message ["result"] to query your API
        // for validating the result
        Map result = message["result"] as Map;

    } else {
        // If the verification fails, it will be refresh automatically.
        debugPrint("Captcha 'onResult' state: $status");
    }
}, onError: (Map<String, dynamic> message) async {
    debugPrint("Captcha onError: " + message.toString());
    String code = message["code"];
    // TODO 
		// Handling errors returned in verification
    if (Platform.isAndroid) {
        // Android platform
        if (code == "-14460") {
	        // The authentication session has been canceled
        } else {
	        // More error codes refer to the development document
	        // <https://docs.geetest.com/gt4/apirefer/errorcode/android>
        }
    }

    if (Platform.isIOS) {
        // iOS platform
        if (code == "-20201") {
	        // Request timeout
        }
        else if (code == "-20200") {
	        // The authentication session has been canceled
        }
        else {
	        // More error codes refer to the development document
	        // <https://docs.geetest.com/gt4/apirefer/errorcode/ios>
        }
    }
});
```