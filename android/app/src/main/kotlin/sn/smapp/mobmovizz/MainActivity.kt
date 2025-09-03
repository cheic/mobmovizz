package sn.smapp.mobmovizz

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import sn.smapp.mobmovizz.widget.WidgetUpdateHelper
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mobmovizz/widget"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateUpcomingWidget") {
                WidgetUpdateHelper.updateUpcomingWidget(this)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
    }
}
