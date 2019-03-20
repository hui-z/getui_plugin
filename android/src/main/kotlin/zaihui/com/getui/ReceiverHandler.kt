package zaihui.com.getui

import com.igexin.sdk.message.GTTransmitMessage
import io.flutter.plugin.common.MethodChannel

object ReceiverHandler {
    var methodChannel: MethodChannel? = null
    fun handleReceivedMessageData(msg: GTTransmitMessage) {
        methodChannel?.invokeMethod("onReceiveMessageData", msg)
    }
    fun onReceiveClientId(clientID: String) {
        methodChannel?.invokeMethod("onReceiveClientId", clientID)
    }
}