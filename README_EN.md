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
  gt4_flutter_plugin: ^0.0.9

```

## Import SDK
**Note: Starting from version 0.0.8, the plugin no longer requires manual import of the SDK. However, for iOS, due to resource reference issues, you still need to manually drag the `GTCaptcha4.bundle` into Xcode.**

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