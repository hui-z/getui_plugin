package zaihui.com.getui

import android.content.Context
import android.util.Log
import com.igexin.sdk.GTIntentService
import com.igexin.sdk.message.GTCmdMessage
import com.igexin.sdk.message.GTNotificationMessage
import com.igexin.sdk.message.GTTransmitMessage


class DefaultReceiverService : GTIntentService() {
    override fun onReceiveMessageData(p0: Context, p1: GTTransmitMessage) {
        println("DefaultReceiverService -------onReceiveMessageData $p1")
        ReceiverHandler.handleReceivedMessageData(p1)
    }

    override fun onNotificationMessageArrived(p0: Context, p1: GTNotificationMessage?) {
        println("DefaultReceiverService -------onNotificationMessageArrived $p1")
    }

    override fun onReceiveServicePid(p0: Context, p1: Int) {
        println("DefaultReceiverService -------onReceiveServicePid $p1")
    }

    override fun onNotificationMessageClicked(p0: Context, p1: GTNotificationMessage?) {
        println("DefaultReceiverService -------onNotificationMessageClicked $p1")
    }

    override fun onReceiveCommandResult(p0: Context, p1: GTCmdMessage?) {
        println("DefaultReceiverService -------onReceiveCommandResult $p1")
    }

    override fun onReceiveClientId(p0: Context, p1: String) {
        ReceiverHandler.onReceiveClientId(p1)
        println("DefaultReceiverService -------onReceiveClientId $p1")
    }

    override fun onReceiveOnlineState(p0: Context, p1: Boolean) {
//        ReceiverHandler.onReceiveOnlineState(p1)
        print("DefaultReceiverService -------onReceiveOnlineState $p1")
        Log.e("DefaultReceiverService", "-------onReceiveOnlineState $p1")
    }
}