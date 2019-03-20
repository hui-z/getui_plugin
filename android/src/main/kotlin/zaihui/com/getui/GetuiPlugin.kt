package zaihui.com.getui

import com.igexin.sdk.PushManager
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
      channel.setMethodCallHandler(GetuiPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "register" -> {
        PushManager.getInstance().initialize(registrar.context(),DefaultPushService::class.java)
        PushManager.getInstance().registerPushIntentService(registrar.context(),DefaultReceiverService::class.java)
      }
      "clientID" -> {
        val clientID =
                PushManager.getInstance().getClientid(registrar.context())
        result.success(clientID)
      }
      else -> result.notImplemented()
    }
  }
}
