package com.geetest.captcha.flutter.gt4_flutter_plugin_example

import android.content.res.Configuration
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor, "gt4_flutter_demo");
        channel?.setMethodCallHandler(this)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        channel?.invokeMethod("configurationChanged", hashMapOf("newConfig" to null))
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }

}
