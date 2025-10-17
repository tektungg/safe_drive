package com.safe.drive

import io.flutter.embedding.android.FlutterFragmentActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.WindowManager

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL_Flavor = "flavor.channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_Flavor).setMethodCallHandler { 
            call, result ->
            if(call.method == "getFlavor") {
                result.success(BuildConfig.FLAVOR)
            }
            else {
                result.notImplemented()
            }
        }
    } 
}
