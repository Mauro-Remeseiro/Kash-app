package com.kash.kash

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Pantalla negra en multitarea + bloquea screenshots
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
