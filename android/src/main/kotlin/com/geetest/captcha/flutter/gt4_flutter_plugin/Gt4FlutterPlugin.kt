package com.geetest.captcha.flutter.gt4_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import com.geetest.captcha.GTCaptcha4Client
import com.geetest.captcha.GTCaptcha4Config
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
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
    private val tag = "| Geetest | Android | "

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gt4_flutter_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initWithCaptcha" -> {
                initWithCaptcha(activity!!, call.arguments)
            }

            "verify" -> {
                verifyWithCaptcha()
            }

            "configurationChanged" -> {
                configurationChanged(Configuration())
            }

            "getPlatformVersion" -> {
                result.success(GTCaptcha4Client.getVersion())
            }

            "close" -> {
                gtCaptcha4Client?.cancel()
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initWithCaptcha(context: Context, param: Any?) {
        if (param !is Map<*, *>) {
            return
        }

        gtCaptcha4Client = GTCaptcha4Client.getClient(context)

        if (param.containsKey("config")) {
            val configBuilder = GTCaptcha4Config.Builder()
            val configParams = param["config"] as Map<String, Any>
            if (configParams.containsKey("resourcePath")) {
                configBuilder.setResourcePath(configParams["resourcePath"] as String)
            }
            val hashMap = HashMap<String, Any>()
            if (configParams.containsKey("protocol")) {
                hashMap["protocol"] = configParams["protocol"] as String
            }
            if (configParams.containsKey("userInterfaceStyle")) {
                hashMap["displayMode"] = configParams["userInterfaceStyle"] as Int
            }
            if (configParams.containsKey("backgroundColor")) {
                val backgroundColorStr = configParams["backgroundColor"] as String
                if (backgroundColorStr.length == 8) {
                    hashMap["bgColor"] = String.format("#%s", backgroundColorStr)
                } else {
                    hashMap["bgColor"] = String.format("#FF%s", backgroundColorStr)
                }
            }
            if (configParams.containsKey("debugEnable")) {
                configBuilder.setDebug(configParams["debugEnable"] as Boolean)
            }
            if (configParams.containsKey("logEnable")) {
                gtCaptcha4Client?.setLogEnable(configParams["logEnable"] as Boolean)
            }
            if (configParams.containsKey("canceledOnTouchOutside")) {
                configBuilder.setCanceledOnTouchOutside(configParams["canceledOnTouchOutside"] as Boolean)
            }
            if (configParams.containsKey("timeout")) {
                configBuilder.setTimeOut(configParams["timeout"] as Int)
            }
            if (configParams.containsKey("language")) {
                configBuilder.setLanguage(configParams["language"] as String)
            }
            if (configParams.containsKey("staticServers")) {
                val staticServers = configParams["staticServers"] as ArrayList<String>
                configBuilder.setStaticServers(staticServers.toTypedArray())
            }
            if (configParams.containsKey("apiServers")) {
                val apiServers = configParams["apiServers"] as ArrayList<String>
                configBuilder.setApiServers(apiServers.toTypedArray())
            }
            if (configParams.containsKey("additionalParameter")) {
                val additionalParameter: Map<String, Any> =
                    configParams["additionalParameter"] as Map<String, Any>
                additionalParameter.forEach {
                    hashMap[it.key] =
                        if (it.value is ArrayList<*>) JSONArray(it.value as ArrayList<*>) else it.value
                }
            }
            configBuilder.setParams(hashMap)
//            if (configParams.containsKey("proxy")) {
//                val proxy: Map<String, Any> = configParams["proxy"] as Map<String, Any>
//                val host: String? = if (proxy.containsKey("host") && proxy["host"] is String) {
//                    proxy["host"] as? String
//                } else {
//                    null
//                }
//                val port: Int? = if (proxy.containsKey("port") && proxy["port"] is Int) {
//                    proxy["port"] as? Int
//                } else {
//                    null
//                }
//                if (host != null && port != null) {
//                    val proxyConfig = GTCaptcha4Proxy(host, port)
//                    configBuilder.setHttpProxyServer(proxyConfig)
//                }
//            }
            gtCaptcha4Client?.init(param["captchaId"] as String, configBuilder.build())
        } else {
            gtCaptcha4Client?.init(param["captchaId"] as String)
        }

    }

    private fun verifyWithCaptcha() {
        gtCaptcha4Client
            ?.addOnSuccessListener { status, response ->
                val jsonObject: JSONObject
                val valueMap = HashMap<String, Any>()
                try {
                    jsonObject = JSONObject(response)
                    val iterator: Iterator<String> = jsonObject.keys()
                    var key: String
                    var value: Any
                    while (iterator.hasNext()) {
                        key = iterator.next()
                        value = jsonObject[key] as Any
                        valueMap[key] = value
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                channel.invokeMethod(
                    "onResult",
                    hashMapOf("status" to if (status) "1" else "0", "result" to valueMap)
                )
            }
            ?.addOnFailureListener { message ->
                val jsonObject = JSONObject(message)
                channel.invokeMethod(
                    "onError",
                    hashMapOf(
                        "code" to jsonObject.optString("code"),
                        "msg" to jsonObject.optString("msg"),
                        "desc" to jsonObject.optJSONObject("desc")?.toString()
                    )
                )
            }
            ?.verifyWithCaptcha()
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
