package com.example.promedapp

import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams;
import android.os.Bundle

class MainActivity: FlutterActivity() {

    override protected fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        getWindow().addFlags(LayoutParams.FLAG_SECURE)
    }

}
