package com.geetest.captcha.flutter.gt4_flutter_plugin

import android.content.res.Configuration
import android.widget.Toast
import com.geetest.captcha.GTCaptcha4Client
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {

    private val CHANNEL = "g4_flutter_plugin"
    private var gtCaptcha4Client: GTCaptcha4Client? = null
    private var methodChannel: MethodChannel? = null;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor, CHANNEL);
        methodChannel?.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result? ->
            if (call.method == "verifyWithCaptcha") {
                verifyWithCaptcha(call.argument<String>("captchaId").toString())
            } else if (call.method == "getPlatformVersion") {
                result?.success(GTCaptcha4Client.getVersion())
            } else if (call.method == "showToast" && call.argument<Any?>("msg") != null) {
                Toast.makeText(this@MainActivity, call.argument<Any>("msg").toString(), Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun verifyWithCaptcha(captchaId: String) {
        gtCaptcha4Client = GTCaptcha4Client.getClient(this)
                .init(captchaId)
                .addOnSuccessListener { state, response ->
                    methodChannel?.invokeMethod("onSuccess", hashMapOf("state" to state, "response" to response))
                }
                .addOnFailureListener { message ->
                    val jsonObject = JSONObject(message)
                    methodChannel?.invokeMethod("onSuccess",
                            hashMapOf("code" to jsonObject.optString("code"),
                                    "msg" to jsonObject.optString("msg"),
                                    "desc" to jsonObject.optJSONObject("desc")?.toString()))
                }
                .verifyWithCaptcha()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        gtCaptcha4Client?.configurationChanged(newConfig)
    }

    override fun onDestroy() {
        super.onDestroy()
        gtCaptcha4Client?.destroy()
    }

}
