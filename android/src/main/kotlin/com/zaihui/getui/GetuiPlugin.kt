package com.zaihui.getui

import com.igexin.sdk.PushManager
import com.igexin.sdk.Tag
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class GetuiPlugin(
        private val registrar: Registrar
): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "getui")
      ReceiverHandler.methodChannel = channel
      channel.setMethodCallHandler(GetuiPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "register" -> {
        PushManager.getInstance().initialize(registrar.context(),DefaultPushService::class.java)
        PushManager.getInstance().registerPushIntentService(registrar.context(),DefaultReceiverService::class.java)
        result.success("")
      }
      "clientID" -> {
        val clientID =
                PushManager.getInstance().getClientid(registrar.context())
        result.success(clientID)
      }
      "setTags" -> {
        if (call.arguments is Array<*>) {
          PushManager.getInstance().setTag(registrar.context(), call.arguments as Array<out Tag>, System.currentTimeMillis().toString())
        }
      }
      "bindAlias" -> {
        if (call.arguments is Array<*>) {
          PushManager.getInstance().bindAlias(registrar.context(), (call.arguments as Array<*>)[0].toString(), (call.arguments as Array<*>)[1].toString() )
        }
      }
      "unbindAlias" -> {
        if (call.arguments is Array<*>) {
          PushManager.getInstance().unBindAlias(registrar.context(), (call.arguments as Array<*>)[0].toString(), (call.arguments as Array<*>)[2] as Boolean, (call.arguments as Array<*>)[1].toString())
        }
      }
      else -> result.notImplemented()
    }
  }
}
