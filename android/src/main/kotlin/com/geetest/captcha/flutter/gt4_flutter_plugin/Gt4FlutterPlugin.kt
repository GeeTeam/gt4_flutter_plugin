package com.geetest.captcha.flutter.gt4_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import androidx.annotation.NonNull
import com.geetest.captcha.GTCaptcha4Client
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** Gt4FlutterPlugin */
class Gt4FlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var activity: Activity? = null
    private lateinit var channel: MethodChannel
    private var gtCaptcha4Client: GTCaptcha4Client? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gt4_flutter_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "verifyWithCaptcha" -> {
                verifyWithCaptcha(activity!!, call.argument<String>("captchaId").toString())
            }
            "configurationChanged" -> {
                configurationChanged(Configuration())
            }
//            "destroy" -> {
//                destroy()
//            }
            "getPlatformVersion" -> {
                result.success(GTCaptcha4Client.getVersion())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun verifyWithCaptcha(context: Context, captchaId: String) {
        gtCaptcha4Client = GTCaptcha4Client.getClient(context)
                .init(captchaId)
                .addOnSuccessListener { state, response ->
                    channel.invokeMethod("onSuccess", hashMapOf("state" to state, "response" to response))
                }
                .addOnFailureListener { message ->
                    val jsonObject = JSONObject(message)
                    channel.invokeMethod("onSuccess",
                            hashMapOf("code" to jsonObject.optString("code"),
                                    "msg" to jsonObject.optString("msg"),
                                    "desc" to jsonObject.optJSONObject("desc")?.toString()))
                }
                .verifyWithCaptcha()
    }

    private fun configurationChanged(newConfig: Configuration?) {
        gtCaptcha4Client?.configurationChanged(newConfig)
    }

    private fun destroy() {
        gtCaptcha4Client?.destroy()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        destroy()
        activity = null
    }

}
