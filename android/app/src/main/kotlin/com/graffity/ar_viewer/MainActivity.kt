package com.graffity.ar_viewer

import android.content.Intent
import androidx.annotation.NonNull
import com.graffity.arcloud.ar.ARCloudActivity
import com.graffity.arcloud.ar.OnSceneTouchedListener

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.graffity.ar-viewer/ar"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "OpenAR") {
                val accessToken = call.argument<String>("accessToken")
//                val intent = Intent(this, ArActivity::class.java) //Start your special native stuff
//                startActivity(intent)
                val intent = Intent(this, ARCloudActivity::class.java)
//                intent.putExtra("OnSceneTouchedListener", OnSceneTouchedListener(onSceneTouchedAction))
                intent.putExtra("PointCloudMode", true)
                intent.putExtra("AccessToken", accessToken)
                startActivity(intent)
                result.success("Success!!!")
            } else {
                result.notImplemented()
            }
        }
    }
}
