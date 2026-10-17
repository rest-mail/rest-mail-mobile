package com.antimatterstudios.restmail

import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Copies a secret, such as a new app password, for
        // lib/util/secret_clipboard.dart. Android has no way to make a copy
        // expire or stay on the device; Android 13 and later can at least
        // keep one marked sensitive out of the clipboard's preview.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "rest-mail/secret-clipboard")
            .setMethodCallHandler { call, result ->
                val text = call.argument<String>("text")
                if (call.method != "copy" || text == null) {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val clip = ClipData.newPlainText("App password", text)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    clip.description.extras = PersistableBundle().apply {
                        putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
                    }
                }
                val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                clipboard.setPrimaryClip(clip)
                // It doesn't expire, and other apps may read it.
                result.success(false)
            }
    }
}
