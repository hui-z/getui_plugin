package zaihui.com.getui

import com.igexin.sdk.message.GTTransmitMessage
import io.flutter.plugin.common.MethodChannel
object ReceiverHandler {
    var methodChannel: MethodChannel? = null
    fun handleReceivedMessageData(msg: GTTransmitMessage) {
        val payload = hashMapOf(
                "appId" to msg.appid,
                "taskId" to msg.taskId,
                "messageId" to msg.messageId,
                "payload" to msg.payload
        )
        methodChannel?.invokeMethod("onReceiveMessageData", payload)
    }
    fun onReceiveClientId(clientID: String) {
        methodChannel?.invokeMethod("onReceiveClientId", clientID)
    }
}