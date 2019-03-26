package zaihui.com.getui

import com.igexin.sdk.message.GTTransmitMessage
import io.flutter.plugin.common.MethodChannel
object ReceiverHandler {
    var methodChannel: MethodChannel? = null
    fun handleReceivedMessageData(msg: GTTransmitMessage) {
        val result = hashMapOf(
                "appId" to msg.appid,
                "taskId" to msg.taskId,
                "messageId" to msg.messageId
        )
        val payload = msg.payload
        if (payload != null) {
            result["payload"] = String(payload)
        }
        methodChannel?.invokeMethod("onReceiveMessageData", result)
    }
    fun onReceiveClientId(clientID: String) {
        methodChannel?.invokeMethod("onReceiveClientId", clientID)
    }
}